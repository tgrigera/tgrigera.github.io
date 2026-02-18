using Bibliography
#using HTML

"Split around math blocks"
function split_math(s)
    collect(eachmatch(r"\$[^$]*\$|[^$]+", s)) .|> m -> m.match
end

"Strip outer brace protection (nested-safe)"
function strip_protect_braces(s)
    return replace(s,"{"=>"","}"=>"")
    # out = IOBuffer()
    # depth = 0
    # for c in s
    #     if c == '{'
    #         depth += 1
    #         if depth > 1
    #             print(out, c)
    #         end
    #     elseif c == '}'
    #         if depth > 1
    #             print(out, c)
    #         end
    #         depth -= 1
    #     else
    #         print(out, c)
    #     end
    # end
    # return String(take!(out))
end

# ----------------------------
# Simple macro replacements
# ----------------------------
const SIMPLE = Dict(
    "ae"=>"æ", "AE"=>"Æ",
    "oe"=>"œ", "OE"=>"Œ",
    "ss"=>"ß", "i" => "i"
)

# ----------------------------
# Accent maps
# ----------------------------
const ACCENTS = Dict(
    "'" => Dict('a'=>"á",'e'=>"é",'i'=>"í",'o'=>"ó",'u'=>"ú",
        'A'=>"Á",'E'=>"É",'I'=>"Í",'O'=>"Ó",'U'=>"Ú",
        'c'=>"ć", 'r'=>"ŕ"),
    "`" => Dict('a'=>"à",'e'=>"è",'i'=>"ì",'o'=>"ò",'u'=>"ù",
                  'A'=>"À",'E'=>"È",'I'=>"Ì",'O'=>"Ò",'U'=>"Ù"),
    "^" => Dict('a'=>"â",'e'=>"ê",'i'=>"î",'o'=>"ô",'u'=>"û",
                  'A'=>"Â",'E'=>"Ê",'I'=>"Î",'O'=>"Ô",'U'=>"Û"),
    "\"" => Dict('a'=>"ä",'e'=>"ë",'i'=>"ï",'o'=>"ö",'u'=>"ü",
                   'A'=>"Ä",'E'=>"Ë",'I'=>"Ï",'O'=>"Ö",'U'=>"Ü"),
    "~" => Dict('n'=>"ñ",'a'=>"ã",'o'=>"õ",
                  'N'=>"Ñ",'A'=>"Ã",'O'=>"Õ"),
    "c" => Dict('c'=>"ç",'C'=>"Ç"),
    "r" => Dict('a'=>"å",'A'=>"Å")
)

"Replace accents and simple macros"
function replace_accents(s::String)
#    ss = replace(s,r"\\i([^A-Za-z])"=>s"i\1")
    ss = s
    # replace \i -> i, \ae etc
    pattern = r"\\(ss|ae|AE|oe|OE|i)([^A-Za-z])"
    matches = eachmatch(pattern,s)
    for mat in matches
        replacement = get(SIMPLE,mat[1],mat.match)*mat[2]
        ss = replace(ss,mat.match => replacement)
    end

    # replace \'a á etc
    pattern = r"\{\\(['`^\"~cr])([A-Za-z])\}|\\(['`^\"~cr])\{([A-Za-z])\}|\\(['`^\"~cr])([A-Za-z])"
    matches = eachmatch(pattern,ss)
    for mat in matches
        i = findfirst(x->!isnothing(x),mat)
        table = ACCENTS[mat[i]]
        replacement = get(table,mat[i+1][1],mat.match)
        ss = replace(ss,mat.match => replacement)
    end
    return ss
end

"Formatting commands"
function replace_formatting(s)
    s = replace(s, r"\\textit\{([^}]*)\}" => s"<i>\1</i>")
    s = replace(s, r"\\emph\{([^}]*)\}"   => s"<i>\1</i>")
    s = replace(s, r"\\textbf\{([^}]*)\}" => s"<b>\1</b>")
    return s
end

const GREEK = Dict(
    "\\alpha"=>"α", "\\beta"=>"β", "\\gamma"=>"γ", "\\delta"=>"δ",
    "\\epsilon"=>"ε", "\\zeta"=>"ζ", "\\eta"=>"η", "\\theta"=>"θ",
    "\\iota"=>"ι", "\\kappa"=>"κ", "\\lambda"=>"λ", "\\mu"=>"μ",
    "\\nu"=>"ν", "\\xi"=>"ξ", "\\pi"=>"π", "\\rho"=>"ρ",
    "\\sigma"=>"σ", "\\tau"=>"τ", "\\upsilon"=>"υ",
    "\\phi"=>"φ", "\\chi"=>"χ", "\\psi"=>"ψ", "\\omega"=>"ω",
    "\\Gamma"=>"Γ", "\\Delta"=>"Δ", "\\Theta"=>"Θ",
    "\\Lambda"=>"Λ", "\\Xi"=>"Ξ", "\\Pi"=>"Π",
    "\\Sigma"=>"Σ", "\\Upsilon"=>"Υ",
    "\\Phi"=>"Φ", "\\Psi"=>"Ψ", "\\Omega"=>"Ω"
)

# const GREEK = Dict(
#     raw"\alpha" => "&alpha;",
#     raw"\beta"  => "&beta;",
#     raw"\gamma" => "&gamma;",
#     raw"\delta" => "&delta;"
# )

"Greek letters (outside math)"
function replace_greek(s)
    for (k,v) in GREEK
        s = replace(s, k => v)
    end
    return s
end

"Dash normalization"
function replace_dashes(s)
    s = replace(s, "---" => "&mdash;")
    s = replace(s, "--"  => "&ndash;")
    return s
end

"Convert math for MathJax"
function convert_math_segment(seg)
    if startswith(seg, '$')
        inner = seg[2:end-1]
        return "\\(" * inner * "\\)"
    else
        return seg
    end
end

function format_title(s::AbstractString)
    segments = split_math(s)

    for i in eachindex(segments)
        seg = segments[i]

        if startswith(seg, '$')
            segments[i] = convert_math_segment(seg)
        else
            seg = strip_protect_braces(seg)
            seg = replace_formatting(seg)
            seg = replace_accents(seg)
            seg = replace_greek(seg)
            seg = replace_dashes(seg)
#            seg = escapehtml(seg)
            segments[i] = seg
        end
    end

    return join(segments)
end

function format_authors(authors)
    fauth = ""
    for (i,auth) ∈ enumerate(authors)
        if i>1 fauth *= ", " end
        fauth *= "$(auth.particle) $(auth.first[1]). "
        if length(auth.middle)>0 fauth *= "$(auth.middle[1]). " end
        fauth *= "$(auth.last)"
    end
    return strip_protect_braces(replace_accents(fauth))
end

function format_entry(bibentry)
    @assert bibentry.type == "article"
    authors = format_authors(bibentry.authors)
    title = format_title(bibentry.title)
    journal = replace_accents(bibentry.in.journal)
    volume = bibentry.in.volume
    pages = replace_dashes(bibentry.in.pages)
    year = bibentry.date.year
    return "$authors, $title. <i>$journal</i> <b>$volume</b>, $pages ($year)."
end

function main()
    bib_file = joinpath(homedir(),"biblio","self.bib")
    bib_odir = joinpath(".","assets","bib")
    pdf_dir = joinpath(bib_odir,"pdf")
    pub_file = joinpath(".","_includes","publications.html")
    rm(pdf_dir,recursive=true,force=true)
    bib = import_bibtex(bib_file)

    # Build dictionary of entries and write BibTeX files
    mkpath(bib_odir)
    entries = Dict()
    links = Dict()
    sorted_keys = []
    for (key,entry) in bib
        x = format_entry(entry)
        entries[key] = x
        push!(sorted_keys,(key,parse(Int,entry.date.year)))
        bfname = joinpath(bib_odir,"$key.bib")
        pdf = get(bib[key].fields,"file","")
        bib[key].fields["file"]=""
        export_bibtex(bfname,entry)
        links[key] = ""
        if bib[key].access.doi != ""
            links[key] *= "<a href=\"https://doi.org/$(bib[key].access.doi)\" target=\"_blank\">DOI</a> | "
        end
        if isfile(pdf)
            dname = joinpath(pdf_dir,basename(dirname(pdf)))
            mkpath(dname)
            fname = joinpath(dname,basename(pdf))
            cp(pdf,fname)
            links[key] *= "<a href=\"/$fname\" target=\"_blank\">PDF</a> | "
        end
        links[key] *= "<a href=\"/$bfname\" download>BibTeX</a>"
    end
    sort!(sorted_keys,by=x->last(x),rev=true)

    # write html publication list
    open(pub_file,"w") do f
        println(f,"<div class=\"publications\">")
        println(f,"<ol class=\"pub-list\">")
        for keyp ∈ sorted_keys
            key = first(keyp)
            println(f,"<li class=\"pub-item\"> $(entries[key])")
            println(f,"<span class=\"pub-links\"> [$(links[key])] </span> </li>")
        end
        println(f,"</ol>")
        println(f,"</div>")
    end

end

if abspath(PROGRAM_FILE) == @__FILE__
    try
        main()
    catch e
        @error "Failed:" exception = e
        exit(1)
    end
end
