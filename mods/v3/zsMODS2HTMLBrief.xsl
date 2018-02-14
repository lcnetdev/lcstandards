<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"

	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:zs="http://www.loc.gov/zing/srw/"
	exclude-result-prefixes="mods zs" >
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	 <!-- Stylesheet to unwrap z3950 search records and transform 
	 MODS3 to HTML: brief version
	-->

<xsl:variable name="dictionary" select="document('http://www.loc.gov/standards/mods/modsDictionary.xml')/dictionary"/>
	<xsl:template match="/">	
		<html>
			<head>
				<style type="text/css">TD {vertical-align:top}</style>
				<title>Search Results: MODS Brief Format</title>
				<link href="http://www.loc.gov/standards/mods/v3/zsCitation.css" type="text/css" rel="stylesheet"/>
			</head>
			<body>
			<table width="90%" align="center" cellspacing="0" bgColor="#ffffcc" >
				<tr><td colspan="3" align="center"><strong>Search Results: MODS Brief Format</strong></td></tr>
				<tr><td colspan="3" bgcolor="white">&#160;</td></tr>
				<xsl:for-each select="zs:searchRetrieveResponse/zs:records/zs:record">
					<xsl:if test="/zs:searchRetrieveResponse/zs:numberOfRecords!=1">
						<tr><td width="8%" bgcolor="white"><strong><xsl:value-of select="concat('Record ',zs:recordPosition)"/></strong></td><td bgcolor="white" colspan="2"/></tr>
					</xsl:if>		
					<xsl:for-each select="zs:recordData/mods:mods">				
							<!--<tr><th align="left">Label</th><th align="left">Value</th></tr>-->
							<tr><td width="8%"/>
								<xsl:call-template name="name"/>
								<xsl:call-template name="title"/>
								<xsl:call-template name="pubInfo"/>
								<xsl:call-template name="callNumber"/>
								<xsl:call-template name="uri"/>								
							</tr>									
					</xsl:for-each>
				</xsl:for-each>			
				</table>
			</body>
		</html>
	</xsl:template>

	<xsl:template match="zs:recordSchema"/>
	<xsl:template match="zs:recordPacking"/>
	<xsl:template match="zs:recordPosition"/>

	<xsl:template name="title">
			<xsl:for-each select="mods:titleInfo">
			<tr>
				<td width="8%"/>
				<td width="20%">Title</td>			
				<td><strong><xsl:value-of select="mods:title/text()"/></strong></td>		
			</tr>
			</xsl:for-each>
	</xsl:template>

	<xsl:template name="pubInfo">
		<xsl:for-each select="mods:originInfo">
		<tr>
			<td width="8%"/>
			<td width="20%">Publication</td>
			<td>
				<xsl:if test="mods:place/mods:placeTerm[@type='text']">
					<xsl:value-of select="mods:place/mods:placeTerm[@type='text']"/>
					<xsl:text>:  </xsl:text>
				</xsl:if>
				<xsl:if test="mods:publisher">						
					<xsl:value-of select="mods:publisher"/>
					<xsl:text>, </xsl:text>
				</xsl:if>
				<xsl:if test="mods:dateIssued">
					<xsl:value-of select="mods:dateIssued"/>
				</xsl:if>
			</td>
		</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="name">
		<xsl:for-each select="mods:name">
		<tr><td width="8%"/>
		<td width="20%">Name 
			<xsl:variable name="label">
				<xsl:choose>
					<xsl:when test="mods:role/mods:roleTerm[@type='text']">
						<xsl:value-of select="mods:role/mods:roleTerm[@type='text']"/>
					</xsl:when>
					<xsl:otherwise><xsl:value-of select="@type"/> </xsl:otherwise>
				</xsl:choose>
			</xsl:variable>

			<xsl:if test="$label">
				(<xsl:choose>
					<xsl:when test="$dictionary/entry[@key=$label]">
						<xsl:value-of select="$dictionary/entry[@key=$label]"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$label"/>
					</xsl:otherwise>
				</xsl:choose>)
			</xsl:if>
			</td>		
		<xsl:variable name="name">
			<xsl:for-each select="mods:namePart">
				<xsl:value-of select="."/><xsl:text> </xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<td><xsl:value-of select="$name"/></td>
		</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="callNumber">
		<xsl:for-each select="mods:classification[@authority='lcc']">		
			<tr><td width="8%"/>
				<td width="20%">LC Call Number</td>
				<td><xsl:value-of select="."/></td>		
			</tr>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="uri">
		<xsl:for-each select="mods:location/mods:url">
			<xsl:if test="@displayLabel">
				<tr><td width="8%"/>
					<td width="20%">Access</td>
					<td>
						<xsl:value-of select="@displayLabel"/>:
					</td>
				</tr>
			</xsl:if>
			<tr><td width="8%"/>
					<td width="20%">Link</td>
					<td>
					<a href="{.}">					
						<xsl:value-of select="."/>								
					</a>
				</td>
			</tr>
		</xsl:for-each>
		
	</xsl:template>

	<xsl:template match="*">
		<xsl:value-of select="text()"/>
	</xsl:template>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Scenario2" userelativepaths="yes" externalpreview="no" url="http://www.loc.gov/standards/mods/instances/mods99042030.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="MODS to HTML" userelativepaths="yes" externalpreview="no" url="..\..\..\temp\zsExample.xml" htmlbaseurl="" outputurl="..\test_files\modshtml.html" processortype="xalan" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="Scenario2" userelativepaths="yes" externalpreview="no" url="http://www.loc.gov/standards/mods/instances/mods99042030.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="no" name="MODS to HTML" userelativepaths="yes" externalpreview="no" url="..\..\..\temp\zsExample.xml" htmlbaseurl="" outputurl="..\test_files\modshtml.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->