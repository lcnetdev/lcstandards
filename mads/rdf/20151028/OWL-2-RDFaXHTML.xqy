xquery version "1.0";

(:
:   Module Name: Take OWL/RDF and Genereate a valid RDF/XHTML
:
:   Module Version: 1.0
:
:   Date: 2012 Aug 17
:
:   Copyright: Public Domain
:
:   Proprietary XQuery Extensions Used: none
:
:   Xquery Specification: January 2007
:
:   Module Overview:    Primary purpose is to take a full OWL
:       RDF/XML representation and generate 
:       a valid RDFa/XHTML.
:
:)
   
(:~
:   Take OWL/RDF and Genereate a valid RDF/XHTML to be 
:   embedded in main div.  In this case, this file is called
:   from RDF-2-RDFaXHTML
:
:   @author Kevin Ford (kefo@loc.gov)
:   @since August 17, 2012
:   @version 1.0
:)

(: NAMESPACES :)
declare namespace fn = "http://www.w3.org/2005/xpath-functions";
declare namespace saxon = "http://saxon.sf.net/";
declare namespace owlxhtml  = 'info:lc/id-modules/owlxhtml#';
declare namespace xhtml     = "http://www.w3.org/1999/xhtml";
declare namespace rdf       = "http://www.w3.org/1999/02/22-rdf-syntax-ns#";
declare namespace rdfs      = "http://www.w3.org/2000/01/rdf-schema#";
declare namespace owl       = "http://www.w3.org/2002/07/owl#";
declare namespace skos      = "http://www.w3.org/2004/02/skos/core#";
declare namespace xsd       = "http://www.w3.org/2001/XMLSchema#";
declare namespace dcterms   = "http://purl.org/dc/terms/";
declare namespace   xdmp            = "http://marklogic.com/xdmp";

declare namespace   bf-abstract="http://bibframe.org/model-abstract/";
declare variable $sourcedoc := doc("mads-ontology.rdf");
(: Imported Modules 
import module namespace constants           = "info:lc/id-modules/constants#" at "constants.xqy";
import module namespace shared              = "info:lc/id-modules/shared#" at "Shared.xqy";
:)

declare variable $owlxhtml:propmap := 
    <mappings>
        <map madsrdf="madsrdf:MADSScheme" skos="skos:ConceptScheme"/>
        <map madsrdf="madsrdf:MADSCollection" skos="skos:Collection"/>
        
        <map madsrdf="madsrdf:Authority" skos="skos:Concept"/>
        <map madsrdf="madsrdf:authoritativeLabel" skos="skos:prefLabel"/>
        
        <map madsrdf="madsrdf:DeprecatedAuthority"/>
        <map madsrdf="madsrdf:deprecatedLabel" skos="skos:hiddenLabel"/>
        
        <map madsrdf="madsrdf:hasVariant" skos="skosxl:altLabel"/>
        <map madsrdf="madsrdf:Variant" skos="skosxl:Label"/>
        <map madsrdf="madsrdf:variantLabel" skos="skosxl:literalForm"/>
        
        <map madsrdf="madsrdf:code" skos="skos:notation"/>
        
        <map madsrdf="madsrdf:hasBroaderAuthority" skos="skos:broader"/>
        <map madsrdf="madsrdf:hasNarrowerAuthority" skos="skos:narrower"/>
        <map madsrdf="madsrdf:hasRelatedAuthority" skos="skos:related"/>
        <map madsrdf="madsrdf:hasEarlierEstablishedForm"/>
        <map madsrdf="madsrdf:hasLaterEstablishedForm" skos="rdfs:seeAlso"/>
        <map madsrdf="madsrdf:see" skos="rdfs:seeAlso"/>
    </mappings>;

declare variable $owlxhtml:NSMAP as element() := 
    <nsmaps>
        <nsmap test="http://www.loc.gov/mads/rdf/v1" display="MADS/RDF">madsrdf</nsmap>
        <nsmap test="http://id.loc.gov/ontologies/lcc" display="LCC">lcc</nsmap>
        <nsmap test="http://www.w3.org/2004/02/skos/core" display="SKOS">skos</nsmap>
        <nsmap test="http://www.w3.org/2008/05/skos-xl" display="SKOSXL">skosxl</nsmap>
        <nsmap test="http://www.w3.org/1999/02/22-rdf-syntax-ns" display="RDF">rdf</nsmap>
        <nsmap test="http://www.w3.org/2000/01/rdf-schema" display="RDFS">rdfs</nsmap>
        <nsmap test="http://purl.org/dc/terms/" display="DCTERMS">dcterms</nsmap>
        <nsmap test="http://www.w3.org/2002/07/owl" display="OWL">owl</nsmap>
        <nsmap test="http://purl.org/vocab/changeset/schema" display="CS">cs</nsmap>
        <nsmap test="http://www.w3.org/2003/06/sw-vocab-status/ns" display="VS">vs</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/iso639-1/" display="ISO6391">iso6391</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/iso639-2/" display="ISO6392">iso6392</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/iso639-5/" display="ISO6395">iso6395</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/languages/" display="MARC">languages</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/countries/" display="MARC">countries</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/geographicAreas/" display="MARC">gacs</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/relators/" display="MARC">relators</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/classSchemes/" display="MARC">classchemes</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/subjectSchemes/" display="MARC">subjectschemes</nsmap>
		<nsmap test="http://id.loc.gov/vocabulary/genreFormSchemes/" display="MARC">genreformschemes</nsmap>
		<nsmap test="http://id.loc.gov/vocabulary/performanceMediums/" display="MARC">performancemediums</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/resourceComponents/" display="MARC">resourceComponents</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/targetAudiences/" display="MARC">audiences</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/descriptionConventions/" display="MARC">descriptionconventions</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/resourceTypes/" display="MARC">resourcetypes</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/identifiers/" display="MARC">identifiers</nsmap>
        <nsmap test="http://www.w3.org/2001/XMLSchema" display="XSD">xsd</nsmap>      
        <nsmap test="http://www.loc.gov/premis/rdf/v1" display="PREMIS">premis</nsmap>
        <nsmap test="http://xmlns.com/foaf/0.1/" display="FOAF">foaf</nsmap>
        <nsmap test="http://www.openarchives.org/ore/terms/" display="ORE">ore</nsmap>
        <nsmap test="http://bibframe.org/vocab/" display="bibframe">bibframe</nsmap>
        <nsmap test="http://id.loc.gov/resources" display="bibframe">bibframe Resources</nsmap>
        <nsmap test="http://id.loc.gov/authorities/demographicTerms/" display="MARC">demographicterms</nsmap>
        <nsmap test="http://id.loc.gov/vocabulary/preservation/rightsRelatedAgentRole" display="rightsRelatedAgentRole">rightsRelatedAgentRole</nsmap>
    </nsmaps>;

(:~
:   This function creates a html:div for RDF data, 
:   the HTML has been augmented with RDFa properties 
:
:   @param  $rdfxml      as element() is the rdf data
:   @return html div element
:)
declare function owlxhtml:owl2rdfaxhtml
    ($rdfxml as element()*) 
    as element(xhtml:div)*
{

    if ($rdfxml/owl:Ontology and ($rdfxml/owl:Class or $rdfxml/rdfs:Class)) then 
        element xhtml:div {
            owlxhtml:generate-Class-list($rdfxml),
            owlxhtml:generate-Property-list($rdfxml),
            owlxhtml:output-Classes($rdfxml),
            owlxhtml:output-Properties($rdfxml)
        }
    else
        <xhtml:div />

};

(:~
:   This function rewrites URIs so that the app works
:   properly in a production or test environment.
:   If the APP is in production, the URL is not rewritten.
:
:   @param  $uri      as xs:string is the URI
:   @return link as string
:)
declare function owlxhtml:rewrite-uri($uri as xs:string)
    as xs:string
{
    fn:replace($uri , 'http://id.loc.gov/', 'http://marklogic3.loc.gov:8293/')
};

(:~
:   This function generates an IMG element for links 
:   when it is determined the link will take the 
:   user to an external website 
:
:   @param  $link      as xs:string is the link
:   @return xhtml:img element, or not

declare function owlxhtml:insert-img-offsite($link as xs:string)
    as element(xhtml:span)*
{
    if (fn:not( fn:contains( $link , 'loc.gov/' ) )) then
        element xhtml:span {
            text {" "},
            element xhtml:img {
                attribute src { "/static/images/newsite.gif" },
                attribute alt { "Offsite link" }
            }
        }
    else ()
};
:)

(:~
:   This function creates a html:div for Class names.
:   Each links to an anchor link within the document  
:
:   @param  $rdf      as element() is the rdf data
:   @return html div element
:)
declare function owlxhtml:generate-Class-list($rdf)
{
    <xhtml:div>
        <xhtml:br />
        <xhtml:a name="link_classList"></xhtml:a>
        <xhtml:h2>Class List</xhtml:h2>
        <xhtml:table class="pORcTable">
                <xhtml:tr>
                    <xhtml:td>
                    {
                        for $r in ($rdf/owl:Class,$rdf/rdfs:Class)
                        let $name := 
                            if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                                fn:substring-after($r/@rdf:about, "#")
                            else
                                xs:string(fn:tokenize(xs:string($r/@rdf:about), "/")[fn:last()])
                        order by $r/@rdf:about
                        return 
                            (
                                element xhtml:a {
                                    attribute href { fn:concat("#" , $name) },
                                    attribute class {"cORp"},
                                    $name
                                },
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                    }
                    </xhtml:td>
                </xhtml:tr>
        </xhtml:table>
    </xhtml:div>
};

(:~
:   This function creates a html:div for Property names.
:   Each links to an anchor link within the document  
:
:   @param  $rdf      as element() is the rdf data
:   @return html div element
:)
declare function owlxhtml:generate-Property-list($rdf)
{
    <xhtml:div>
        <xhtml:br />
        <xhtml:a name="link_propList"></xhtml:a>
        <xhtml:h2>Property List</xhtml:h2>
        <xhtml:table class="pORcTable">
                <xhtml:tr>
                    <xhtml:td>
                    {
                        for $r in $rdf/(owl:*|rdf:*)[fn:local-name() ne "Ontology" and fn:local-name() ne "Class"]|$rdf/rdfs:Resource[rdf:type/@rdf:resource = "http://bibframe.org/model-abstract/BFProperty"]
                        let $name := 
                            if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                                fn:substring-after($r/@rdf:about, "#")
                            else
                                xs:string(fn:tokenize(xs:string($r/@rdf:about), "/")[fn:last()])
                        order by $r/@rdf:about
                        return 
                            (
                                element xhtml:a {
                                    attribute href { fn:concat("#" , $name) },
                                    attribute class {"cORp"},
                                    $name
                                },
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                    }
                    </xhtml:td>
                </xhtml:tr>
        </xhtml:table>
    </xhtml:div>
};

(:~
:   This function generates a table row for a property.  
:
:   @param  $p      as element()* is the property
:   @param  $label  as xs:string() is the table row label
:   @return xhtml:tr* element
:)
declare function owlxhtml:generate-property-row($p, $label) {

    if ( fn:count($p) > 0 ) then
        <xhtml:tr>
            <xhtml:td class="tdleft">{$label}:</xhtml:td>
            <xhtml:td>
                {
                    for $pc in $p
                    return 
                        if ($pc/@rdf:resource) then
                            (
                                owlxhtml:pORcLink(xs:string($pc/@rdf:resource)),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                        else if ($pc[fn:name() eq "owl:disjointUnionOf"]) then
                            (
                                for $dsu at $pos in $pc//@rdf:resource
                                return
                                     ( owlxhtml:pORcLink(xs:string($dsu)),
                                      if ($pc//@rdf:resource[$pos + 1]) then
                                        " ∪ "
                                      else ()),
                               fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                                       
                        else if ($pc/@rdf:about) then
                            (
                                owlxhtml:pORcLink(xs:string($pc/@rdf:about)),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                                
                        else if ($pc/owl:Restriction/owl:onProperty) then
                            (
                                owlxhtml:restrictionLine($pc/owl:Restriction),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )


                        else if ($pc/owl:Class/owl:intersectionOf/owl:Restriction) then
                            (
                                "( ",
                            
                                for $c at $pos in $pc/owl:Class/owl:intersectionOf/owl:Restriction
                                return
                                (
                                    owlxhtml:restrictionLine($c),
                                    if ($pc/owl:Class/owl:intersectionOf/owl:Restriction[$pos + 1]) then
                                        " ∩ "
                                    else ()
                                ),
                                
                                " )",
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                        
                        else if ($pc/owl:Class/owl:unionOf/owl:Restriction) then
                            (
                                "( ",
                            
                                for $c at $pos in $pc/owl:Class/owl:unionOf/owl:Restriction
                                return
                                (
                                    owlxhtml:restrictionLine($c),
                                    if ($pc/owl:Class/owl:unionOf/owl:Restriction[$pos + 1]) then
                                        " ∪ "
                                    else ()
                                ),
                                
                                " )",
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                            
                        else if ($pc/owl:Class/owl:unionOf) then
                            
                            let $classes := 
                                for $c at $pos in $pc/owl:Class/owl:unionOf/owl:Class
                                return
                                    (
                                        owlxhtml:pORcLink(xs:string($c/@rdf:about)),
                                        if ($pc/owl:Class/owl:unionOf/owl:Class[$pos + 1]) then
                                            " ∪ "
                                        else (fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' '))
                                    )
                            return $classes
                        
                        else if ($pc/owl:Class/@rdf:about) then
                            (
                                owlxhtml:pORcLink(xs:string($pc/owl:Class/@rdf:about)),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                            
                        else if ($pc/owl:ObjectProperty/@rdf:about) then
                            (
                                owlxhtml:pORcLink(xs:string($pc/owl:ObjectProperty/@rdf:about)),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                        else if ($pc[fn:name() eq "rdfs:comment"] and fn:contains(fn:string($pc), "madsrdf:")) then
                            (

                                let $mf := fn:replace(fn:string($pc), "madsrdf:([a-zA-Z]+)", "<xhtml:a href='#$1' class='cORp'>$0</xhtml:a>")                        
                                let $mf := fn:parse-xml-fragment(fn:concat("<xhtml:html xmlns:xhtml='http://www.w3.org/1999/xhtml'>", $mf, "</xhtml:html>"))
                                return 
                                    $mf,
                                    fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                        else
                            (
                                xs:string($pc),
                                fn:concat('&#160;','&#160;','&#160;','&#160;','&#160;', ' ')
                            )
                }
            </xhtml:td>
        </xhtml:tr>
    else    
        ()

};


declare function owlxhtml:output-Classes($rdf)
{

    <xhtml:div>
        <xhtml:h2>Classes</xhtml:h2>
    {
        for $r in ($rdf/owl:Class,$rdf/rdfs:Class)
        let $name := 
            if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                fn:substring-after($r/@rdf:about, "#")
            else
                xs:string(fn:tokenize(xs:string($r/@rdf:about), "/")[fn:last()])
        order by $r/@rdf:about
        return 
        (
        <xhtml:a name="{$name}"></xhtml:a>,
        <xhtml:table class="pORcTable">            
                 <xhtml:tr class="trheading">
                    <xhtml:td class="tdleft">Class:</xhtml:td>
                    <xhtml:td>
                        {
                            let $ns := 
                                if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                                    fn:substring-before($r/@rdf:about, "#")
                                else
                                    let $parts := fn:tokenize(xs:string($r/@rdf:about), "/")
                                    return fn:concat(fn:string-join($parts[fn:position() ne fn:last()], "/"), "/")
                            let $nsprefix := xs:string($owlxhtml:NSMAP/nsmap[@test eq $ns][1])
                            return fn:concat($nsprefix , ":" , $name)
                        }
                    </xhtml:td>
                </xhtml:tr> 
                  {
                    (
                        owlxhtml:generate-property-row($r/rdfs:label, "Label"),
                        owlxhtml:generate-property-row($r/skos:definition|$r/bf-abstract:definition, "Definition"),
                        owlxhtml:generate-property-row($r/rdfs:comment, "Comment"),
                        owlxhtml:generate-property-row($r/skos:scopeNote, "Scope Note"),
                        owlxhtml:generate-property-row($r/skos:editorialNote, "Editorial Note"),
                        owlxhtml:generate-property-row($r/skos:historyNote, "History Note"),
                        owlxhtml:generate-property-row($r/rdf:type, "Type"),
                        owlxhtml:generate-property-row($r/rdfs:subClassOf, "SubClass Of"),
                        owlxhtml:generate-property-row($rdf/owl:Class[rdfs:subClassOf/@rdf:resource = $r/@rdf:about], "Has SubClasses"),
                        owlxhtml:generate-property-row($rdf/(owl:ObjectProperty | owl:DatatypeProperty | rdf:Property | owl:AnnotationProperty)[rdfs:range/@rdf:resource eq $r/@rdf:about]|$rdf/rdfs:Resource[rdfs:range/@rdf:resource = $r/@rdf:about] , "Used with"),
                        owlxhtml:generate-property-row($rdf/(owl:ObjectProperty | owl:DatatypeProperty | rdf:Property | owl:AnnotationProperty)[rdfs:domain/@rdf:resource eq $r/@rdf:about]|$rdf/rdfs:Resource[rdfs:domain/@rdf:resource = $r/@rdf:about], "Properties include"),
                        owlxhtml:generate-property-row($r/owl:disjointWith, "Disjoint with"),
                        owlxhtml:generate-property-row($r/owl:equivalentClass, "Equivalent Class"),
                        owlxhtml:generate-property-row($r/owl:disjointUnionOf, "Disjoint Union Of")
                    )
                
                }
                
                <xhtml:tr>
                  <xhtml:td colspan="2" class="tdbottomrow"> 
                        [<xhtml:a class="bottomrow" href="#link_classList">back to class list</xhtml:a>] 
                        [<xhtml:a class="bottomrow" href="#link_top">back to top</xhtml:a>] 
                  </xhtml:td>
              </xhtml:tr>
        </xhtml:table>,
        <xhtml:br></xhtml:br>,
        <xhtml:br></xhtml:br>
        )

    }
    </xhtml:div>

};


declare function owlxhtml:output-Properties($rdf)
{

    <xhtml:div>
        <xhtml:h2>Properties</xhtml:h2>
    {
        for $r in $rdf/rdf:Property|$rdf/owl:ObjectProperty|$rdf/owl:DatatypeProperty|$rdf/owl:AnnotationProperty|$rdf/owl:FunctionalProperty|$rdf/owl:InverseFunctionalProperty|$rdf/rdfs:Resource[rdf:type/@rdf:resource = "http://bibframe.org/model-abstract/BFProperty"]
        let $name := 
            if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                fn:substring-after($r/@rdf:about, "#")
            else
                xs:string(fn:tokenize(xs:string($r/@rdf:about), "/")[fn:last()])
        order by $r/@rdf:about
        return 
        (
        <xhtml:a name="{$name}"></xhtml:a>,
        <xhtml:table class="pORcTable">            
                <xhtml:tr class="trheading">
                    <xhtml:td class="tdleft">Property:</xhtml:td>
                    <xhtml:td>
                        {
                            let $ns := 
                                if ( fn:contains( xs:string($r/@rdf:about), "#") ) then
                                    fn:substring-before($r/@rdf:about, "#")
                                else
                                    let $parts := fn:tokenize(xs:string($r/@rdf:about), "/")
                                    return fn:concat(fn:string-join($parts[fn:position() ne fn:last()], "/"), "/")
                            let $nsprefix := xs:string($owlxhtml:NSMAP/nsmap[@test eq $ns][1])
                            return fn:concat($nsprefix , ":" , $name)
                        }
                    </xhtml:td>
                </xhtml:tr>
                
                {
                    (
                        owlxhtml:generate-property-row($r/rdfs:label, "Label"),
                        owlxhtml:generate-property-row(($r/skos:definition, $r/bf-abstract:definition), "Definition"),
                        owlxhtml:generate-property-row($r/rdfs:comment, "Comment"),
                        owlxhtml:generate-property-row($r/skos:scopeNote, "Scope Note"),
                        owlxhtml:generate-property-row($r/skos:editorialNote, "Editorial Note"),
                        owlxhtml:generate-property-row($r/skos:historyNote, "History Note")
                    )
                }
                {
                    let $el-name := fn:name($r)
                    let $el-local-name := fn:local-name($r)
                    let $prefix := fn:substring-before($el-name, ":")
                    let $ns := xs:string($owlxhtml:NSMAP/nsmap[. = $prefix][1]/@test)
                    let $ns := 
                        if ( fn:ends-with($ns, "/") ) then
                            $ns
                        else
                            fn:concat($ns, "#")
                    let $t := element rdf:type { attribute rdf:resource { fn:concat($ns, $el-local-name) } }
                    let $types := ($t, $r/rdf:type)
                    return owlxhtml:generate-property-row($types, "Type")
                }
                {
                    (
                        owlxhtml:generate-property-row($r/rdfs:subPropertyOf, "SubProperty Of"),
                        owlxhtml:generate-property-row($r/rdfs:domain, "Domain"),
                        owlxhtml:generate-property-row($r/rdfs:range, "Range")
                    )
                
                }
                
                <xhtml:tr>
                  <xhtml:td colspan="2" class="ontTDbottomrow"> 
                        [<xhtml:a class="bottomrow" href="#link_propList">back to property list</xhtml:a>] 
                        [<xhtml:a class="bottomrow" href="#link_top">back to top</xhtml:a>] 
                  </xhtml:td>
               </xhtml:tr>
        </xhtml:table>,
        <xhtml:br></xhtml:br>,
        <xhtml:br></xhtml:br>
        )

    }
    </xhtml:div>

};

(:~
:   When given a URI, this extracts details 
:   about the namespace.
:
:   @param  $uri         as string 
:   @return item sequence of link and off-site image, if material
:)
declare function owlxhtml:pORcLink(
    $uri as xs:string
    ) as item()*
{
    let $name := fn:substring-after($uri, "#")
    let $ns := fn:substring-before($uri, "#")
                            
    let $name := 
        if ( fn:not(fn:contains($uri, "#")) ) then
            let $parts := fn:tokenize($uri, "/")
            return $parts[fn:count($parts)]
        else
            $name
                                    
    let $ns := 
        if ( fn:not(fn:contains($uri, "#")) ) then
            let $parts := fn:tokenize($uri, "/")
            let $parts := 
                for $i at $pos in $parts
                where $pos < fn:count($parts)
                return $i
            let $recombine := fn:string-join($parts, "/")
            let $recombine := fn:concat($recombine, "/")
            return $recombine
        else
            $ns
                            
    let $nsprefix := xs:string($owlxhtml:NSMAP/nsmap[@test eq $ns][1])
    let $link := xs:string($uri)
        
    return
        ( 
            element xhtml:a {
                attribute href { owlxhtml:rewrite-uri($link) },
                fn:concat($nsprefix , ":" , $name)
            }
            (:,
            owlxhtml:insert-img-offsite($link):)
        )

};

(:~
:   Creates a line that details the property/class restriction
:
:   @param  $restriction as owl:Restriction element
:   @return item sequence of restriction info
:)
declare function owlxhtml:restrictionLine(
        $restriction as element(owl:Restriction)
        ) as item()*
{

    let $onProp := (
                        $restriction/owl:onProperty/@rdf:resource|
                        $restriction/owl:onProperty/owl:ObjectProperty/@rdf:about|
                        $restriction/owl:onProperty/owl:DatatypeProperty/@rdf:about|
                        $restriction/owl:onProperty/owl:AnnotationProperty/@rdf:about
                    )[1]
    let $onClass := ($restriction/owl:onClass/@rdf:resource|$restriction/owl:onClass/owl:Class/@rdf:about)[1]
    let $cardinality := (
                        $restriction/owl:minQualifiedCardinality|
                        $restriction/owl:maxQualifiedCardinality|
                        $restriction/owl:qualifiedCardinality|
                        $restriction/owl:cardinality|
                        $restriction/owl:minCardinality|
                        $restriction/owl:maxCardinality
                    )[1]
    let $onDataRange := ($restriction/owl:onDataRange/@rdf:resource|$restriction/owl:hasValue/@rdf:resource)[1]
    return
    (
        "[Restriction] ",
        
        if ( $onProp) then
            if ( fn:local-name($onProp/parent::node()[1]) eq "onProperty" ) then
                ("On property " , owlxhtml:pORcLink(xs:string($onProp)) )
            else
                owlxhtml:pORcLink(xs:string($onProp))
        else "",
        
        if ( fn:local-name($cardinality) eq "minQualifiedCardinality" or fn:local-name($cardinality) eq "minCardinality") then
            " min "
        else if ( fn:local-name($cardinality) eq "maxQualifiedCardinality" or fn:local-name($cardinality) eq "maxCardinality") then
            " max "
        else if ( fn:local-name($cardinality) eq "qualifiedCardinality") then
            " exactly "
        else if ( fn:local-name($cardinality) eq "cardinality") then
            " exactly "
        else "",
        
        if ( $cardinality ne "") then
            fn:concat($cardinality, " ")
        else "",
        
        if ($onClass) then
            owlxhtml:pORcLink(xs:string($onClass))
        else if ( fn:local-name($onDataRange/parent::node()[1]) eq "hasValue") then
            (" with value ", <xhtml:a href="{xs:string($onDataRange)}">{xs:string($onDataRange)}</xhtml:a>)
        else if ($onDataRange) then
            owlxhtml:pORcLink(xs:string($onDataRange))
        else 
            owlxhtml:pORcLink("http://www.w3.org/2002/07/owl#Thing")
            
    )

};

declare function owlxhtml:htmlwrapper ($xhtml) 
{
<xhtml:html>
    <xhtml:head>
        <xhtml:meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
        <xhtml:title>MADS/RDF Namespace Document</xhtml:title>
        <xhtml:link href="../madsrdf-style.css" rel="stylesheet"/>
    </xhtml:head>
    <xhtml:body>
        <xhtml:center>
            <xhtml:div class="container"><xhtml:a name="link_top"></xhtml:a><xhtml:h1>MADS/RDF Namespace Document</xhtml:h1>
            <xhtml:p><span class="emphasis">Status: </span>Published
            </xhtml:p>
            <xhtml:p><span class="emphasis">Updated</span>: 28 October 2015
            </xhtml:p>
            <xhtml:p class="heading">Introduction</xhtml:p>
            <xhtml:p></xhtml:p>
            <xhtml:p>MADS/RDF (Metadata Authority Description Schema in RDF) is a knowledge organization system (KOS) designed for use with controlled
               values for names (personal, corporate, geographic, etc.), 
               thesauri, taxonomies, subject heading systems, and other controlled value lists.  It is closely related to SKOS, the Simple
               Knowledge Organization System and a widely supported and 
               adopted RDF vocabulary.  MADS/RDF has been fully mapped to SKOS.  It is presented as an OWL ontology.
            </xhtml:p>
            <xhtml:p>The MADS/RDF is designed as a data model for authority and vocabulary data used within the library and information science
               (LIS) 
               community, which is inclusive of museums, archives, and other cultural institutions.  For example, MADS/RDF provides a means
               to 
               record data from the Machine Readable Cataloging (MARC) Authorities format in RDF for use in 
               semantic applications and Linked Data projects.   
               
            </xhtml:p>
            <xhtml:p class="heading">MADS/RDF Schema Overview</xhtml:p>
            <xhtml:p> The following is a non-normative overview of MADS/RDF classes and properties. This document can be referenced directly (<xhtml:a href="http://www.loc.gov/standards/mads/rdf/v1.html">http://www.loc.gov/standards/mads/rdf/v1.html</xhtml:a>) or
               indirectly by content negotiation from the MADS/RDF namespace URI (<xhtml:a href="http://www.loc.gov/mads/rdf/v1#">http://www.loc.gov/mads/rdf/v1#</xhtml:a>). There are three normative variants, all of which can be accessed directly also: <xhtml:br></xhtml:br><xhtml:br></xhtml:br><xhtml:a href="http://www.loc.gov/standards/mads/rdf/v1.rdf">MADS/RDF Namespace Document - RDF/XML</xhtml:a><xhtml:br></xhtml:br><xhtml:br></xhtml:br><xhtml:a href="http://www.loc.gov/standards/mads/rdf/v1.nt">MADS/RDF Namespace Document - n-triples</xhtml:a><xhtml:br></xhtml:br><xhtml:br></xhtml:br><xhtml:a href="http://www.loc.gov/standards/mads/rdf/v1.n3">MADS/RDF Namespace Document - n3/turtle</xhtml:a></xhtml:p>
            <xhtml:p>A related text, the <xhtml:a href="index.html">MADS/RDF Primer</xhtml:a>, provides additional details about the design and intent of MADS/RDF.  There are also numerous examples.
            </xhtml:p><xhtml:br></xhtml:br>
             {$xhtml}
            <xhtml:br></xhtml:br>
            <xhtml:h2>Acknowledgements</xhtml:h2>
            <xhtml:table class="pORcTable" style="padding: 4px;">
               <xhtml:tr>
                  <xhtml:td>
                     The MADS/RDF to SKOS/RDF mapping was done by Antoine Isaac. The MADS/RDF model and ontology benefited significantly as a result
                     of the fruitful discussions surrounding his effort to map the MADS/RDF ontology to SKOS.               
                  </xhtml:td>
               </xhtml:tr>
            </xhtml:table><xhtml:br></xhtml:br></xhtml:div>
      </xhtml:center>
   <xhtml:script type='text/javascript' src='http://cdn.loc.gov/js/global/metrics/sc/v25.2/2.0/s_code.js'/>     
    </xhtml:body>
</xhtml:html>

};

let $output := (
    for $i in $sourcedoc
    let $n := $i/*
    return owlxhtml:owl2rdfaxhtml($n))
return owlxhtml:htmlwrapper($output)


