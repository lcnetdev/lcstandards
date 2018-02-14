<?xml version='1.0'?>
<xsl:stylesheet exclude-result-prefixes="marc" version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:import href="MARC21slimUtils.xsl"/>
	<xsl:output method="html"/>

	<xsl:template match="/marc:record">
	<html><head/>
		<body>
			<p>
				<strong>
					<xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='a']"/>
				</strong>
				<xsl:value-of select="marc:datafield[@tag=100]/marc:subfield[@code='d']"/>
				<br/>
				<xsl:for-each select="marc:datafield[@tag=245]">
					<xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">apbc</xsl:with-param></xsl:call-template>
				</xsl:for-each> -- 
				<xsl:value-of select="marc:datafield[@tag=250]/marc:subfield[@code='a']"/>-- 
			</p>
			<p>
				<xsl:for-each select="marc:datafield[@tag=300]">
					<xsl:call-template name="subfieldSelect"><xsl:with-param name="codes">abc</xsl:with-param></xsl:call-template>
				</xsl:for-each>
			</p>
			<xsl:for-each select="marc:datafield[@tag=500]/marc:subfield[@code='a']">
				<p>
					<xsl:value-of select="."/>
				</p>
			</xsl:for-each>
		</body>
	</html>
</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\CVS\marc4j\dist\lib\soccer.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->