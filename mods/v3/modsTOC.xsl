<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="mods">
	<xsl:output method="xml"  indent="yes" encoding="UTF-8"/>
	<!-- MODS3 Table of Contents to HTML -->

	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">TD {vertical-align:bottom}	
				</style>
				<title><xsl:value-of select="descendant-or-self::mods:titleInfo/mods:title"/></title>
			</head>
			<body>
				<xsl:choose>
					<xsl:when test="mods:modsCollection">
				 		<xsl:apply-templates select="mods:modsCollection"/>		 
					</xsl:when>
					<xsl:when test="mods:mods">
			 			<xsl:apply-templates select="mods:mods"/>		 
					</xsl:when>
				</xsl:choose>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="mods:modsCollection">
		<xsl:apply-templates select="mods:mods"/>
		<hr/>
	</xsl:template>

	<xsl:template match="mods:mods">
	<!-- title -->	
		<h3><xsl:value-of select="mods:titleInfo/mods:title"/>
		<xsl:if test="mods:titleInfo/mods:subTitle">
			<br/>
			<span style="margin-left:1em"><xsl:value-of select="mods:titleInfo/mods:subTitle"/></span>
		</xsl:if>
		</h3>
	<!-- author -->		
		<h4>
		<xsl:if test="mods:name">
			<em><strong>
				<xsl:for-each select="mods:name">
					<xsl:for-each select="mods:namePart">
						<xsl:value-of select="text()"/>
					</xsl:for-each>
					<br/>
				</xsl:for-each>
			</strong></em>			
		</xsl:if>		
		<!-- identifiers -->
		<xsl:if test="mods:identifier">
			<xsl:for-each select="mods:identifier[text()!='']">
				<strong><xsl:value-of select="@type"/></strong>
				<xsl:text>:  </xsl:text>
				<xsl:value-of select="."/>
			</xsl:for-each>			
		</xsl:if>
		</h4>
		<!-- related items (chapters, sections, etc, recursively -->
		<table width="70%"  bgcolor="silver" align="center">
		<th align="left"> <strong>Contents</strong></th>
			<tr><td align="left">
					<ul><xsl:apply-templates select="mods:relatedItem[@type='constituent']"/></ul>
				</td>
			</tr>
		</table>		
	</xsl:template>
	
	<xsl:template match="mods:relatedItem[@type='constituent']">		
		<li><xsl:value-of select="mods:titleInfo/mods:title"/>		
			<xsl:if test="mods:name">
				<xsl:call-template name="names"/>
			</xsl:if>
			<xsl:if test="mods:relatedItem">
				<!-- next level content item if any -->
				<ul>
					<xsl:apply-templates select="mods:relatedItem[@type='constituent']"/>
				</ul>
			</xsl:if>
		</li>		
	</xsl:template>
	
	<xsl:template name="names">											
		<xsl:variable name="nameList">
			<xsl:for-each select="mods:name">							
				<xsl:value-of select="normalize-space(.)"/><xsl:text>, </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<br/>
		<strong style="margin-left:1em"><xsl:value-of select="substring($nameList,1,string-length($nameList)-2)"/></strong>
	</xsl:template>

</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario4" userelativepaths="yes" externalpreview="no" url="..\test_files\TOCmods.xml" htmlbaseurl="" outputurl="..\..\..\temp\x.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\ntra\ndmso\TOCmods.xml" htmlbaseurl="" outputurl="..\..\..\temp\x.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->