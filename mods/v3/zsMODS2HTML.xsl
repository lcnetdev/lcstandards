<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"

	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:zs="http://www.loc.gov/zing/srw/"
	exclude-result-prefixes="mods zs" >
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	 <!-- Stylesheet to unwrap z3950 search records and transform 
	 MODS3 to HTML
	-->

	<xsl:include href="http://www.loc.gov/standards/mods/mods.xsl"/>

	<xsl:template match="/">
	
		<html>
			<head>
				<style type="text/css">TD {vertical-align:top}</style>
				<title>Search Results: MODS Full Format</title>
			</head>
			<body>
				<xsl:for-each select="zs:searchRetrieveResponse/zs:records/zs:record">
					<xsl:if test="/zs:searchRetrieveResponse/zs:numberOfRecords!=1">
						<p><strong><xsl:value-of select="concat('Record ',zs:recordPosition)"/></strong></p>
					</xsl:if>
					<xsl:for-each select="zs:recordData">
						<xsl:apply-templates/>				
					</xsl:for-each>
				</xsl:for-each>			
			</body>
		</html>
	</xsl:template>

	<xsl:template match="zs:recordSchema"/>
	<xsl:template match="zs:recordPacking"/>
	<xsl:template match="zs:recordPosition"/>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Scenario2" userelativepaths="yes" externalpreview="no" url="http://www.loc.gov/standards/mods/instances/mods99042030.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="MODS to HTML" userelativepaths="yes" externalpreview="no" url="http://z3950.loc.gov:7090/voyager?operation=searchRetrieve&amp;version=1.1&amp;query=dc.title=dhtml%20and%20dc.creator=%22callihan,%20steven%22&amp;recordSchema=mods&amp;startRecord=1&amp;maximumRecords=10&amp;recordPacking=xml" htmlbaseurl="" outputurl="..\test_files\modshtml.html" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->