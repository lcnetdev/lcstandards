<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="xs rdf madsrdf owl xsd rdfs vars xsl" 
    xmlns:xd="http://www.oxygenxml.com/ns/doc/xsl"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
    xmlns:madsrdf="http://id.loc.gov/ontologies/mads/2010/11#" 
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:xsd="http://www.w3.org/2001/XMLSchema#" 
    xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#" 
    xmlns:vars="vars#" 
    xmlns="http://www.w3.org/1999/xhtml" 
    version="2.0">
    <xsl:import href="http://exslt.org/date/functions/date-time/date.date-time.xsl"/>
    <xd:doc scope="stylesheet">
        <xd:desc>
            <xd:p><xd:b>Created on:</xd:b> Mar 18, 2011</xd:p>
            <xd:p><xd:b>Author:</xd:b> kford</xd:p>
            <xd:p/>
        </xd:desc>
    </xd:doc>
<!-- 
*******************************
adapted for MODS RDF, by Ray Denenberg, March 2012  
****************************
-->


    <xsl:output encoding="UTF-8" indent="yes" method="xhtml"/>

    <xsl:variable name="namespaces">
        <vars:namespaces>
            <vars:ns prefix="owl" value="http://www.w3.org/2002/07/owl#"/>
            <vars:ns prefix="rdf" value="http://www.w3.org/1999/02/22-rdf-syntax-ns#"/>
            <vars:ns prefix="rdfs" value="http://www.w3.org/2000/01/rdf-schema#"/>
            <vars:ns prefix="xsd" value="http://www.w3.org/2001/XMLSchema#"/>
            <vars:ns prefix="foaf" value="http://xmlns.com/foaf/0.1/"/>
            <vars:ns prefix="skos" value="http://www.w3.org/2004/02/skos/core#"/>
            <vars:ns prefix="skosxl" value="http://www.w3.org/2008/05/skos-xl#"/>
            <!-- <vars:ns prefix="madsrdf" value="http://id.loc.gov/ontologies/mads/2010/11#"/> -->
            <vars:ns prefix="madsrdf" value="#"/>
        </vars:namespaces>
    </xsl:variable>
    
    
    
        <xsl:variable name="localNamespaces">
        <vars:namespaces>
            <vars:ns prefix="ri" value="http://id.loc.gov/ontologies/RecordInfo#"/>
   <vars:ns prefix="madsrdf" value="http://www.loc.gov/mads/rdf/v1#"/> 
            <vars:ns prefix="modsrdf" value="#"/>
        </vars:namespaces>
    </xsl:variable>
    
<!--    <xsl:variable name="mads2skos" select="document('mappings.rdf')"/>  -->
    <xsl:variable name="mads2skos">
<xsl:text>mads2skos</xsl:text>    
    </xsl:variable> 

    <xsl:template match="/rdf:RDF">
        <html>
            <head>
                <meta http-equiv="Content-Type" content="text/html; charset=UTF-8"></meta>

                <title>MODS/RDFNamespace Document</title>
                <link href="madsrdf-style.css" rel="stylesheet"></link>
            </head>
            <body>
            
                    <div class="container">
                        <a name="link_top"/>
                                        <center>
                        <h1>MODS/RDFNamespace Document</h1>
                        <p><span class="emphasis">Status: </span>DRAFT</p>
                        <p><span class="emphasis">Updated: </span><xsl:value-of select="current-dateTime()" /></p>
</center>
                      
                        
                        
                        <a name="link_classList"/>
                        <h2>Class List</h2>
                    <h4>(Sorted according to their labels)</h4>    
                        <table class="pORcTable">
                            <tr>
                                <td>
                                    <xsl:apply-templates select="owl:Class" mode="classList">
                                       <xsl:sort select="rdfs:label"/>                                      
                                    </xsl:apply-templates>
                                </td>
                            </tr>
                        </table>
                        <br/>
                        <a name="link_propList"/>
                        <h2>Property List</h2>
                                   <h4>(Sorted according to their labels)</h4> 
                      <table class="pORcTable">
                            <tr>
                                <td>
                                    <xsl:apply-templates select="*[contains(name() , 'Property')]" mode="propertyList">
                                        <xsl:sort select="rdfs:label"/> 
                                    </xsl:apply-templates>
                                </td>
                            </tr>
                        </table>   
                        <br/>


                        <h2>Classes</h2>
                        <xsl:apply-templates select="owl:Class">
                            <xsl:sort select="rdfs:label"/>
                        </xsl:apply-templates>


                        <h2>Properties</h2>
                        <xsl:apply-templates select="*[contains(name() , 'Property')]" mode="properties">
                             <xsl:sort select="rdfs:label[1]"/> 
                        </xsl:apply-templates>
                        

                        <br/>
                    </div>
         
            </body>
        </html>
    </xsl:template>

    <xsl:template match="*" mode="classList">
        <xsl:variable name="qname">
            <xsl:call-template name="qname">
                <xsl:with-param name="qn">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
<!--        <xsl:if test="contains($qname , 'modsrdf:')">  -->
            <!-- <a href="{concat('#link_' , $qname)}" class="cORp"> -->
            <a href="{concat('#' , substring-after($qname, ':'))}" class="cORp">
<!--                <xsl:value-of select="substring-after($qname , ':')"/>  -->
<xsl:value-of select="$qname"/> 
            </a>
            <xsl:call-template name="spaces"/>
<!--        </xsl:if> -->
    </xsl:template>

    <xsl:template match="*" mode="propertyList">
        <xsl:variable name="qname">
            <xsl:call-template name="qname">
                <xsl:with-param name="qn">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
<!--        <xsl:if test="contains($qname , 'modsrdf:')">  -->
            <!-- <a href="{concat('#link_' , $qname)}" class="cORp"> -->
            <a href="{concat('#' , substring-after($qname, ':'))}" class="cORp">
<xsl:value-of select="substring-after($qname , ':')"/>  

            </a>
            <xsl:call-template name="spaces"/>
<!--        </xsl:if> -->
    </xsl:template>





    <xsl:template match="owl:Class">
        <xsl:variable name="cname">
            <xsl:choose>
                <xsl:when test="contains(@rdf:about|@rdf:ID, ':')">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:when>
                <xsl:when test="contains(@rdf:about|@rdf:ID, '#')">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('#' , @rdf:about|@rdf:ID)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="qname">
            <xsl:call-template name="qname">
                <xsl:with-param name="qn">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!--<a name="{concat('link_',$qname)}"/>-->
        <a name="{substring-after($qname , ':')}"/>
        <table class="pORcTable">
            <tr class="trheading">
                <td class="tdleft">
                    Class:
                </td>
                <td>
                    <xsl:value-of select="$qname"/>
                    <br/>
                </td>
            </tr>
<!--            <xsl:if test="rdfs:label">  -->
                <tr>
                    <td class="tdleft">Label: </td>
                    <td>
<!--                        <xsl:apply-templates select="rdfs:label"/>  -->
<xsl:value-of select="rdfs:label"/>

                    </td>
                </tr>
<!--            </xsl:if>  -->
            <xsl:if test="rdfs:comment">
                <tr>
                    <td class="tdleft">Comment: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:comment"/>
                        <br/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:call-template name="rdftypes"/>
            <xsl:if test="rdfs:subClassOf or $mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/rdfs:subClassOf">
                <tr>
                    <td class="tdleft">SubClass Of: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:subClassOf"/>
                        <xsl:apply-templates select="$mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/rdfs:subClassOf"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:call-template name="hasSubClasses">
                <xsl:with-param name="cname" select="$cname"/>
            </xsl:call-template>
            <xsl:call-template name="usedWith">
                <xsl:with-param name="cname" select="$cname"/>
            </xsl:call-template>
            <xsl:call-template name="propsInclude">
                <xsl:with-param name="cname" select="$cname"/>
            </xsl:call-template>
            <xsl:if test="owl:disjointWith">
                <tr>
                    <td class="tdleft">Disjoint With: </td>
                    <td>
                        <xsl:apply-templates select="owl:disjointWith"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="owl:disjointUnionOf">
                <tr>
                    <td class="tdleft">Disjoint Union Of: </td>
                    <td>
                        <xsl:apply-templates select="owl:disjointUnionOf"/>
                    </td>
                </tr>
            </xsl:if>
            <!--
            <xsl:if test="$mads2skos/rdf:RDF/rdf:Description[@rdf:about eq concat('http://www.loc.gov/mads/rdf/v1' , $cname)]">
                <tr>
                    <td class="tdleft">SKOS Mapping: </td>
                    <td>
                        <xsl:apply-templates select="$mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/*"/>
                    </td>
                </tr>  
            </xsl:if>
            -->
            <!--  
Following commented out for MODS RDF
            <tr class="trbottomrow">
                <td colspan="2" class="tdbottomrow"> [<a class="bottomrow" href="#link_classList">back to class list</a>] [<a class="bottomrow" href="#link_top">back to top</a>] </td>
            </tr>-->
        </table>
        <br/>
        <br/>
    </xsl:template>

    <xsl:template match="*" mode="properties">
        <xsl:variable name="cname">
            <xsl:choose>
                <xsl:when test="contains(@rdf:about|@rdf:ID, ':')">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:when>
                <xsl:when test="contains(@rdf:about|@rdf:ID, '#')">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="concat('#' , @rdf:about|@rdf:ID)"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="qname">
            <xsl:call-template name="qname">
                <xsl:with-param name="qn">
                    <xsl:value-of select="@rdf:about|@rdf:ID"/>
                </xsl:with-param>
            </xsl:call-template>
        </xsl:variable>
        <!--<a name="{concat('link_',$qname)}"/>-->
        <a name="{substring-after($qname , ':')}"/>
        <table class="pORcTable">
            <tr class="trheading">
                <td width="200">
                    <b>Property: </b>
                </td>
                <td>
                    <b>
                        <xsl:call-template name="qname">
                            <xsl:with-param name="qn">
                                <xsl:value-of select="@rdf:about|@rdf:ID"/>
                            </xsl:with-param>
                        </xsl:call-template>
                    </b>
                    <br/>
                </td>
            </tr>
            <xsl:if test="rdfs:label">
                <tr>
                    <td>Label: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:label"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:comment">
                <tr>
                    <td>Comment: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:comment"/>
                        <br/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:call-template name="rdftypes"/>
            <xsl:if test="rdfs:subPropertyOf or $mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/rdfs:subPropertyOf">
                <tr>
                    <td>SubProperty Of: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:subPropertyOf"/>
                        <xsl:apply-templates select="$mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/rdfs:subPropertyOf"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:domain">
                <tr>
                    <td>Domain: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:domain"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="rdfs:range">
                <tr>
                    <td>Range: </td>
                    <td>
                        <xsl:apply-templates select="rdfs:range"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="owl:inverseOf">
                <tr>
                    <td>Inverse Of: </td>
                    <td>
                        <xsl:apply-templates select="owl:inverseOf"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            <xsl:if test="$mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/owl:equivalentProperty">
                <tr>
                    <td>Equivalent Property: </td>
                    <td>
                        <xsl:apply-templates select="$mads2skos/rdf:RDF/rdf:Description[@rdf:about=concat('http://www.loc.gov/mads/rdf/v1' , $cname)]/owl:equivalentProperty"/>
                        <xsl:call-template name="spaces"/>
                    </td>
                </tr>
            </xsl:if>
            
            <!-- following commented out for MODS RDF.
            <tr class="trbottomrow">
                <td colspan="2" class="tdbottomrow"> [<a class="bottomrow" href="#link_propList">back to property list</a>] [<a class="bottomrow" href="#link_top">back to top</a>] </td>
            </tr>-->
        </table>
        <br/>
        <br/>
    </xsl:template>

    <xsl:template match="rdfs:label">
        <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="rdfs:comment">
        <xsl:call-template name="text">
            <xsl:with-param name="t">
                <xsl:value-of select="text()"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>
    <xsl:template name="rdftypes">
        <tr>
            <td class="tdleft">Type(s): </td>
            <td>
                <xsl:variable name="qn" select="name()"/>
                <xsl:call-template name="internalLink">
                    <xsl:with-param name="qn" select="$qn"/>
                </xsl:call-template>
                <xsl:call-template name="spaces"/>
                <xsl:for-each select="rdf:type">
                    <xsl:variable name="qn" select="@rdf:resource"/>
                    <xsl:call-template name="internalLink">
                        <xsl:with-param name="qn" select="$qn"/>
                    </xsl:call-template>
                    <xsl:call-template name="spaces"/>
                </xsl:for-each>
            </td>
        </tr>
    </xsl:template>
    <xsl:template match="rdfs:subClassOf|owl:disjointWith|owl:disjointUnionOf|rdfs:subPropertyOf|rdfs:domain|rdfs:range|owl:inverseOf|owl:equivalentProperty">
        <xsl:choose>
            <xsl:when test="owl:Class/owl:unionOf[@rdf:parseType='Collection']|
                self::node()[name()='owl:disjointUnionOf' and @rdf:parseType='Collection']/owl:Class">
                <xsl:for-each
                    select="owl:Class/owl:unionOf[@rdf:parseType='Collection']/owl:Class
                    |self::node()[name()='owl:disjointUnionOf' and @rdf:parseType='Collection']/owl:Class">
                    <xsl:if test="preceding-sibling::node()[name() eq 'owl:Class']">
                        <xsl:text> &#8746; </xsl:text>
                    </xsl:if>
                    <xsl:variable name="qn" select="@rdf:about|@rdf:ID"/>
                    <xsl:call-template name="internalLink">
                        <xsl:with-param name="qn" select="$qn"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:when>
            <xsl:otherwise>
                <xsl:for-each select="owl:*|rdf:Property">
                    <xsl:variable name="qn" select="@rdf:about|@rdf:ID"/>
                    <xsl:call-template name="internalLink">
                        <xsl:with-param name="qn" select="$qn"/>
                    </xsl:call-template>
                    <xsl:call-template name="spaces"/>
                </xsl:for-each>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="@rdf:resource">
            <xsl:variable name="qn" select="@rdf:resource"/>
            <xsl:call-template name="internalLink">
                <xsl:with-param name="qn" select="$qn"/>
            </xsl:call-template>
            <xsl:call-template name="spaces"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="hasSubClasses">
        <xsl:param name="cname"/>
        <xsl:if test="/rdf:RDF/owl:Class/rdfs:subClassOf[@rdf:resource[.=$cname] or owl:Class/@rdf:about[.=$cname]]">
            <tr>
                <td class="tdleft">Has SubClasses: </td>
                <td class="tdright">
                    <xsl:for-each select="/rdf:RDF/owl:Class/rdfs:subClassOf[@rdf:resource[.=$cname] or owl:Class/@rdf:about[.=$cname] or owl:Class/@rdf:ID[.=substring-after($cname,'#')]]">
                        <xsl:variable name="qn" select="../@rdf:about|../@rdf:ID"/>
                        <xsl:call-template name="internalLink">
                            <xsl:with-param name="qn" select="$qn"/>
                        </xsl:call-template>
                        <xsl:call-template name="spaces"/>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="propsInclude">
        <xsl:param name="cname"/>
        <xsl:if test="/rdf:RDF/child::node()[rdfs:domain/@rdf:resource[.=$cname]]">
            <tr>
                <td>Properties Include: </td>
                <td>
                    <xsl:for-each select="/rdf:RDF/child::node()[rdfs:domain/@rdf:resource[.=$cname]]">
                        <xsl:variable name="qn" select="@rdf:about|@rdf:ID"/>

                        <xsl:call-template name="internalLink">
                            <xsl:with-param name="qn" select="$qn"/>
                        </xsl:call-template>
                        <xsl:call-template name="spaces"/>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="usedWith">
        <xsl:param name="cname"/>
        <xsl:if test="/rdf:RDF/child::node()[rdfs:range/@rdf:resource[.=$cname]]">
            <tr>
                <td>Used With: </td>
                <td>
                    <xsl:for-each select="/rdf:RDF/child::node()[rdfs:range/@rdf:resource[.=$cname]]">
                        <xsl:variable name="qn" select="@rdf:about|@rdf:ID"/>

                        <xsl:call-template name="internalLink">
                            <xsl:with-param name="qn" select="$qn"/>
                        </xsl:call-template>
                        <xsl:call-template name="spaces"/>
                    </xsl:for-each>
                </td>
            </tr>
        </xsl:if>
    </xsl:template>

    <xsl:template name="text">
        <xsl:param name="t"/>
        <xsl:for-each select="tokenize($t , ' ')">
            <xsl:choose>
                <xsl:when test="contains(. , ':')">
                    <xsl:variable name="qn">
                        <xsl:value-of select="."/>
                    </xsl:variable>
                    <xsl:call-template name="internalLink">
                        <xsl:with-param name="qn" select="$qn"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> </xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="internalLink">
        <xsl:param name="qn"/>

        <xsl:variable name="qnamestr">
            <xsl:call-template name="qname">
                <xsl:with-param name="qn" select="$qn"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="qname">
            <xsl:choose>
                <xsl:when test="contains($qnamestr , ',')">
                    <xsl:value-of select="substring-before($qnamestr , ',')"/>
                </xsl:when>
                <xsl:when test="contains($qnamestr , '.')">
                    <xsl:value-of select="substring-before($qnamestr , '.')"/>
                </xsl:when>
                <xsl:when test="contains($qnamestr , ')')">
                    <xsl:value-of select="substring-before($qnamestr , ')')"/>
                </xsl:when>
                <xsl:when test="contains($qnamestr , '(')">
                    <xsl:value-of select="substring-after($qnamestr , '(')"/>
                </xsl:when>
                <xsl:when test="contains($qnamestr , ';')">
                    <xsl:value-of select="substring-after($qnamestr , ';')"/>
                </xsl:when>
                <xsl:otherwise><xsl:value-of select="$qnamestr"/></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--<xsl:variable name="link">
            <xsl:choose>
                <xsl:when test="starts-with($qname , 'http://')">
                    <xsl:value-of select="$qname"/>
                </xsl:when>
                <xsl:when test="$namespaces/vars:namespaces/vars:ns[@prefix=substring-before($qname , ':')]">
                    <xsl:value-of
                        select="concat(
                        $namespaces/vars:namespaces/vars:ns[@prefix=substring-before($qname , ':')]/@value , 
                            substring-after($qname , ':'))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <!-\- <xsl:value-of select="$namespaces/namespaces/ns[@prefix=substring-before($qname , ':')]"/> -\->
                    <xsl:value-of select="concat('#link_' , $qname)"/>
                </xsl:otherwise>
            </xsl:choose>
            </xsl:variable>-->
        <xsl:variable name="link">
            <xsl:choose>
                <xsl:when test="starts-with($qname , 'http://')">
                    <xsl:value-of select="$qname"/>
                </xsl:when>
                <xsl:when test="$namespaces/vars:namespaces/vars:ns[@prefix=substring-before($qname , ':')]">
                    <xsl:value-of
                        select="concat(
                        $namespaces/vars:namespaces/vars:ns[@prefix=substring-before($qname , ':')]/@value , 
                        substring-after($qname , ':'))"
                    />
                </xsl:when>
                <xsl:otherwise>
                    <!-- <xsl:value-of select="$namespaces/namespaces/ns[@prefix=substring-before($qname , ':')]"/> -->
                    <!--<xsl:value-of select="concat('#link_' , $qname)"/>-->
                    <xsl:value-of select="concat('#' , substring-after($qname , ':'))"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <a href="{$link}" class="cORp">
            <xsl:value-of select="$qnamestr"/>
        </a>
    </xsl:template>

    <xsl:template name="qname">
        <xsl:param name="qn"/>
        <xsl:choose>
            <xsl:when test="starts-with($qn , 'http://')">
                <xsl:variable name="prefix">
                    <xsl:for-each select="$namespaces/vars:namespaces/vars:ns">
                        <xsl:if test="starts-with($qn , @value)">
                            <xsl:value-of select="@prefix"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:variable name="propORclass">
                    <xsl:for-each select="$namespaces/vars:namespaces/vars:ns">
                        <xsl:if test="starts-with($qn , @value)">
                            <xsl:value-of select="substring-after($qn , @value)"/>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:variable>
                <xsl:value-of select="concat(
                    $prefix[1],
                    ':',
                    $propORclass
                    )"/>
            </xsl:when>
            <xsl:when test="contains($qn, ':')">
                <xsl:value-of select="$qn"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat('modsrdf:' , translate($qn , '#' , ''))"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="spaces">
        <xsl:text>&#160;&#160;&#160;&#160; </xsl:text>
    </xsl:template>
</xsl:stylesheet>
