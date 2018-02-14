<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
	<xsl:template match="marc:collection">
		<collection>
			<xsl:apply-templates/>
		</collection>
	</xsl:template>
	
	<xsl:template match="marc:record">
		<record>
			<xsl:call-template name="copyAttributes"/>
			<xsl:apply-templates select="marc:leader"/>
			<xsl:apply-templates select="marc:controlfield"/>
			<controlfield tag="003">DLC</controlfield>
			<xsl:apply-templates select="marc:datafield"/>
		</record>
	</xsl:template>

	<xsl:template name="copyAttributes">
		<xsl:for-each select="@*">
			<xsl:attribute name="{local-name()}"><xsl:value-of select="."/></xsl:attribute>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="marc:leader">
		<leader>
			<xsl:call-template name="copyAttributes"/>
			<xsl:value-of select="."/>
		</leader>
	</xsl:template>

	<xsl:template match="marc:datafield">
		<xsl:variable name="subfields">
			<xsl:apply-templates/>		
		</xsl:variable>
		<xsl:if test="count($subfields)">
			<datafield>
				<xsl:call-template name="copyAttributes"/>
				<xsl:copy-of select="$subfields"/>
			</datafield>
		</xsl:if>
	</xsl:template>

	<xsl:template match="marc:controlfield">
		<controlfield>
			<xsl:call-template name="copyAttributes"/>
			<xsl:value-of select="."/>
		</controlfield>
	</xsl:template>

	<xsl:template match="marc:subfield">
		<subfield>
			<xsl:call-template name="copyAttributes"/>
			<xsl:value-of select="."/>
		</subfield>
	</xsl:template>

	<xsl:template match="marc:subfield[@code=9]"/>

	<xsl:template match="marc:datafield[@tag>=900]"/>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2002 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="no" name="Rebecca" userelativepaths="yes" externalpreview="no" url="..\xml\MARC21slim\rebecca.xml" htmlbaseurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\validation\sister.xml" htmlbaseurl="" processortype="custom" commandline="java  &#x2D;jar C:\saxon7&#x2D;1\saxon7.jar &#x2D;o %3 %1 %2" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->