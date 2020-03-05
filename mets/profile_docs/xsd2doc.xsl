<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xsd="http://www.w3.org/2001/XMLSchema" version="1.0">
<!-- Brian Tingle, UC Regents, Digital Library Federation, METS Board
This xslt turns the mets.xsd into a handy html reference

xsltproc -o index.html xsd2doc.xsl http://www.loc.gov/standards/mets/mets.xsd
-->

<xsl:key name="element-name" match="//xsd:element" use="@name"/>

<xsl:key name="complexType-name" match="//xsd:complexType" use="@name"/>

<!-- -->
<xsl:template match="xsd:schema">
<html>
<head>
<title>XML Schema documentation for 
<xsl:value-of select="@targetNamespace"/>
</title>
</head>
<body>
<style type="text/css">
div { padding: 5px; border:1px dashed #ccc; }
.documentation { background:#eee; }
div.attributes { border:1px dashed #000; }
.element	   { border:1px solid #0c0; }
.complexType   { border:1px solid #000; }
</style>
<div><a name="toc"><h1>Schema Documentation
{<xsl:value-of select="@targetNamespace"/>}
</h1></a>
	<h2>Contents</h2>
	<div><a class="onpage" href="#element">Elements</a>
	</div>

	<div><a class="onpage" href="#complexType">Named Complex Types</a>
	</div>
	<!-- <div>Attribute Groups</div> -->

</div>

<div>
<a name="element"><h2>Elements</h2></a>

<!-- muenchian technique -->

		<div><xsl:apply-templates select=".//xsd:element    [count( . | key('element-name'    ,./@name)[1]) = 1]" mode="linkTo">
	<xsl:sort select="translate (@name, 'abcdefghijklmnopqrstuvwxyz1234567890@', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ###########')"/>
</xsl:apply-templates>

</div>
	<xsl:apply-templates select=".//xsd:element"/>
</div>

<div>
<a name="complexType"><h2>Named Complex Types</h2></a>
		<div>
		<xsl:apply-templates select=".//xsd:complexType[count( . | key('complexType-name',./@name)[1]) = 1 and @name]" mode="linkTo"> 
	<xsl:sort select="@name"/>
</xsl:apply-templates>
		</div>
	<xsl:apply-templates select=".//xsd:complexType[@name]"/>
</div>
<p>
<a href="http://findaid.oac.cdlib.org/mets/schema_documentation/xsd2doc.xsl">xsd2doc.xsl</a>
</p>
</body>
</html>
</xsl:template>

<xsl:template name="nav-bar">
<a href="#toc" class="onpage">Contents</a> |
<a href="#element" class="onpage">Elements</a> |
<a href="#complexType" class="onpage">Named Complex Types</a> 
</xsl:template>

<!-- complexType linkTo -->
<xsl:template match="xsd:complexType" mode="linkTo">
	<!-- <div class="link"><a class="onpage" href="#{@name}"><xsl:value-of select="@name"/></a> -->
| <a class="onpage" href="#{@name}"><xsl:value-of select="@name"/></a>
</xsl:template>

<!-- element linkTo -->
<xsl:template match="xsd:element" mode="linkTo">
|	<a class="onpage" href="#{@name}">&lt;<xsl:value-of select="@name"/>&gt;</a>
</xsl:template>


<!-- default/main xsd:element xsd:complexType -->

<!-- -->
<xsl:template match="xsd:complexType">
<div class="complexType">
	<a name="{@name}"><h3>Complex type <xsl:value-of select="@name"/></h3></a>
<div>elements of this type
<xsl:variable name="this" select="@name"/>
<xsl:apply-templates select="//xsd:element[@type=$this]" mode="linkTo"/>
<xsl:for-each select="//xsd:extension[@base=$this]">
  <xsl:apply-templates select="../../.." mode="linkTo"/>
</xsl:for-each>
</div>

<xsl:apply-templates select="./xsd:annotation/xsd:documentation"/>
<xsl:if test="*/xsd:element">
	<div>may contain
	<xsl:apply-templates select="*/xsd:element" mode="linkTo"/>
	</div>
</xsl:if>

	<div class="attributes">
<p>attributes</p>
<xsl:apply-templates select="xsd:attribute"/>
<xsl:apply-templates select="xsd:attributeGroup"/>
<xsl:apply-templates select="xsd:anyAttribute"/>
</div>
<xsl:call-template name="nav-bar"/>

</div>
</xsl:template>

<!-- main element main -->
<xsl:template match="xsd:element">
<div class="element">
	<a name="{@name}"><h3>Element &lt;<xsl:value-of select="@name"/>&gt;</h3></a>
<xsl:for-each select="@*">
<xsl:choose>
 <xsl:when test="name()='name'"/>
 <xsl:when test="name()='type'">type=&quot;<a href="#{.}"><xsl:value-of select="."/></a>&quot;
 </xsl:when>
 <xsl:otherwise>
  <xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;
 </xsl:otherwise>
</xsl:choose>
<![CDATA[ ]]>
</xsl:for-each>


<xsl:apply-templates select="./xsd:annotation/xsd:documentation"/>
<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
<xsl:variable name="othertype"><xsl:value-of select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/></xsl:variable>
<xsl:if test="string-length($othertype) &gt; 0">
<div>complexType
	<xsl:apply-templates select="//xsd:complexType[@name=$othertype]" mode="linkTo"/>
</div>
</xsl:if>
<xsl:if test="string-length($type) + string-length($othertype) &gt; 0">
<div>may contain
	<xsl:apply-templates select="//xsd:complexType[@name=$type]/*/xsd:element" mode="linkTo"/>
	<xsl:apply-templates select="//xsd:complexType[@name=$othertype]/*/xsd:element" mode="linkTo"/>
</div>
</xsl:if>

<xsl:if test="./*/*/xsd:element">
<div>
may contain
	<xsl:apply-templates select="./*/*/xsd:element" mode="linkTo"/>
</div>
</xsl:if>
<div>
<xsl:variable name="contained"><xsl:call-template name="contained"/></xsl:variable>
<xsl:if test="string-length($contained)&gt;1">contained within <xsl:copy-of select="$contained"/>
</xsl:if>
</div>

	<xsl:call-template name="attributes"/> 
<![CDATA[
]]>
<xsl:call-template name="nav-bar"/>
</div>
</xsl:template>

<!-- figures out what can contain me -->
<xsl:template name="contained">
<xsl:variable name="this"><xsl:value-of select="@name"/>
</xsl:variable>
<xsl:for-each select="//xsd:element">
<!-- if it may contain me -->
<xsl:if test="(./*/*/xsd:element/@name)=$this">
<xsl:apply-templates select="." mode="linkTo"/>
</xsl:if>
</xsl:for-each>
<xsl:for-each select="//xsd:complexType">
<xsl:if test="(./*/xsd:element/@name)=$this">
<xsl:variable name="that"><xsl:value-of select="@name"/>
</xsl:variable>
<!-- <xsl:apply-templates select="." mode="linkTo"/> -->
<xsl:apply-templates select="//xsd:element[@type=$that]" mode="linkTo"/>
<xsl:for-each select="//xsd:extension[@base=$that]">
<xsl:apply-templates select="../../.." mode="linkTo"/>
</xsl:for-each>
</xsl:if>
</xsl:for-each>
</xsl:template>

<!-- unused? -->
<xsl:template match="xsd:element" mode="contained">
<xsl:apply-templates select="./*/*/xsd:element" mode="linkTo"/>
</xsl:template>

<!-- -->
<xsl:template name="attributes">
<div class="attributes">
<p>attributes</p>
<!-- this list built by trial and error with the METS schema -->
<xsl:apply-templates select="./xsd:complexType/xsd:attribute"/>
<xsl:apply-templates select="./xsd:complexType/xsd:attributeGroup"/>
<xsl:apply-templates select="./xsd:complexType/xsd:complexContent/xsd:restriction/xsd:attribute"/>
<xsl:apply-templates select="./xsd:complexType/xsd:complexContent/xsd:restriction/xsd:attributeGroup"/>
<xsl:apply-templates select="./xsd:complexType/xsd:attributeGroup"/>
<xsl:apply-templates select="./xsd:complexType/xsd:anyAttribute/xsd:annotation/xsd:documentation"/>
<xsl:variable name="type"><xsl:value-of select="@type"/></xsl:variable>
<xsl:apply-templates select="//xsd:complexType[@name=$type]/xsd:attribute | //xsd:complexType[@name=$type]/xsd:anyAttribute"/>
<xsl:apply-templates select="./xsd:complexType/*/xsd:extension/xsd:attribute | ./xsd:complexType/*/xsd:extension/xsd:anyAttribute"/>

<xsl:variable name="othertype"><xsl:value-of select="xsd:complexType/xsd:complexContent/xsd:extension/@base"/></xsl:variable>
<xsl:apply-templates select="//xsd:complexType[@name=$othertype]/xsd:attribute | //xsd:complexType[@name=$othertype]/xsd:anyAttribute"/>
</div>
</xsl:template>

<!-- -->
<xsl:template match="xsd:attributeGroup">
<xsl:variable name="ref"><xsl:value-of select="@ref"/></xsl:variable>
<p>attributeGroup ref:<xsl:value-of select="@ref"/></p>
<xsl:apply-templates select="//xsd:attributeGroup[@name=$ref]/*"/>
</xsl:template>

<!-- -->
<xsl:template match="xsd:attribute">
<div>
<!-- <xsl:copy-of select="."/> -->
<xsl:value-of select="@name"/>: 
<xsl:value-of select="@type"/>
<xsl:value-of select="@ref"/>
<![CDATA[ ]]>&#160;
<xsl:value-of select="@use"/>
<![CDATA[ ]]>&#160;
<xsl:apply-templates select=".//xsd:enumeration"/>
	<div>
	<xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
	</div>
</div>
</xsl:template>

<xsl:template match="xsd:anyAttribute">
	<xsl:apply-templates select="xsd:annotation/xsd:documentation"/>
</xsl:template>

<!-- -->
<xsl:template match="xsd:enumeration">
| <xsl:value-of select="@value"/>
</xsl:template>

<!-- -->
<xsl:template match="xsd:annotation/xsd:documentation">
	<div class="documentation">
<xsl:call-template name="substitute">
         <xsl:with-param name="string" select="." />
      </xsl:call-template>
</div>
</xsl:template>

<!-- http://www.dpawson.co.uk/xsl/sect2/break.html -->
<xsl:template name="substitute">
   <xsl:param name="string" />
   <xsl:param name="from" select="'&#xA;'" />
   <xsl:param name="to">
      <br />
   </xsl:param>
   <xsl:choose>
      <xsl:when test="contains($string, $from)">
         <xsl:value-of select="substring-before($string, $from)" />
         <xsl:copy-of select="$to" />
         <xsl:call-template name="substitute">
            <xsl:with-param name="string"
                            select="substring-after($string, $from)" />
            <xsl:with-param name="from" select="$from" />
            <xsl:with-param name="to" select="$to" />
         </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
         <xsl:value-of select="$string" />
      </xsl:otherwise>
   </xsl:choose>
</xsl:template>       

</xsl:stylesheet>
