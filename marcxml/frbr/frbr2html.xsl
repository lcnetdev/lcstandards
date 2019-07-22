<?xml version="1.0"?>
<xsl:stylesheet xmlns:frbr="http://www.loc.gov/MARC21/frbr" xmlns:mods="http://www.loc.gov/mods/" version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html"/>

	<xsl:variable name="languages" select="document('http://www.loc.gov/standards/iso639-2/langcodes.xml')/languages"/>

	<xsl:template match="/frbr:frbr">


		<html>
			<head>
				<style type="text/css">
ul {
  list-style-type: disc;
}
				</style>
			</head>
			<body>
				<ul>
					<xsl:apply-templates select="frbr:work"/>
				</ul>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="frbr:work">
		<xsl:choose>
		<xsl:when test="mods:name">
			<li><b>Author: <xsl:value-of select="mods:name/mods:namePart"/></b></li>
		</xsl:when>
		<xsl:otherwise>
			<li><b>Author: Not entered under author</b></li>
		</xsl:otherwise>
		</xsl:choose>
		<li>
		<b>Work: <xsl:value-of select="mods:titleInfo/mods:title"/> 
			<xsl:for-each select="mods:titleInfo/mods:partName|mods:titleInfo/mods:partNumber">
				<xsl:text> </xsl:text>
				<xsl:value-of select="."/>
			</xsl:for-each>
			</b>
			</li>

		<ul>
			<xsl:apply-templates select="frbr:expression"/>
		</ul>
	</xsl:template>

	<xsl:template match="frbr:expression">
		<li><i>Form: <xsl:value-of select="mods:typeOfResource"/>
		<xsl:if test="mods:language">
			<xsl:variable name="languageCode" select="mods:language"/>
			 - <xsl:value-of select="$languages/language[@ISO639-2B=$languageCode]/@English"/>
		 </xsl:if></i>
		 </li>
		<ul>
			<xsl:apply-templates select="frbr:manifestation"/>
		</ul>
	</xsl:template>

	<xsl:template match="frbr:manifestation">
		<xsl:apply-templates select="frbr:imprint"/>
	</xsl:template>

	<xsl:template match="frbr:imprint">
		<li>Edition: <xsl:value-of select="mods:originInfo/mods:edition"/></li>
		<ul>
			<xsl:for-each select="mods:titleInfo">
					<li>Title: 
					<a href="http://catalog.loc.gov/cgi-bin/Pwebrecon.cgi?DB=local&amp;CMD=lccn+{../mods:identifier[@type='lccn']}&amp;CNT=25+records+per+screen">
					<xsl:value-of select="mods:title"/><xsl:if test="mods:subTitle"><xsl:text>: </xsl:text><xsl:value-of select="mods:subTitle"/></xsl:if></a></li>
			</xsl:for-each>
			<xsl:for-each select="mods:note">
				<li>Statement of responsibility: <xsl:value-of select="."/></li>
			</xsl:for-each>
			<xsl:for-each select="mods:originInfo">

			<!-- fix comma when no publisher -->

				<li>Imprint: <xsl:value-of select="mods:publisher"/><xsl:if test="mods:publisher and mods:dateIssued">, </xsl:if><xsl:value-of select="mods:dateIssued"/></li>
			</xsl:for-each>
			<xsl:for-each select="mods:physicalDescription">
				<li>Physical Description: <xsl:value-of select="."/></li>
			</xsl:for-each>
			<xsl:for-each select="mods:identifier[@type!='lccn']">
				<li>
					<xsl:value-of select="@type"/>: <xsl:value-of select="."/></li>
			</xsl:for-each>
		</ul>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="musicfrbr.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->