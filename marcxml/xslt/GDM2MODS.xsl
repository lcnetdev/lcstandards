<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:template match="/">
		<xsl:apply-templates select="ArchObj/DescMD/DMD/GDM"/>
	</xsl:template>

	<xsl:template match="GDM">
		<mods>
			<xsl:for-each select="Content[@FieldType='conAbstract']">
				<abstract>
					<xsl:value-of select="."/>
				</abstract>
			</xsl:for-each>
			<xsl:for-each select="Content[@FieldType='conGeneral']">
				<note type="content">
					<xsl:value-of select="."/>
				</note>
			</xsl:for-each>
			<xsl:for-each select="Content[@FieldType='conScopeContent']">
				<abstract>
					<xsl:value-of select="."/>
				</abstract>
			</xsl:for-each>
			<xsl:for-each select="Content[@FieldType='conStylePeriod']">
			</xsl:for-each>

			<xsl:for-each select="Content[@FieldType='conStylePeriod']">
			</xsl:for-each>

			<xsl:for-each select="Core/Caption">
				<note type="caption">
					<xsl:value-of select="."/>
				</note>
			</xsl:for-each>		

			<xsl:for-each select="Core/Dimensions">
				<physicalDescription>
					<xsl:value-of select="."/>
				</physicalDescription>
			</xsl:for-each>

			<xsl:for-each select="Core/LocalID">
				<identifier type="local">
					<xsl:value-of select="."/>
				</identifier>
			</xsl:for-each>

			<xsl:for-each select="Core/Title">
				<titleInfo>
					<title>
						<xsl:value-of select="."/>
					</title>
				</titleInfo>
			</xsl:for-each>

			<xsl:for-each select="Creator">
				<name authority="{@Source}">
					<namePart>
						<xsl:value-of select="."/>
					</namePart>
					<role>
						<xsl:value-of select="@Role"/>
					</role>
				</name>
			</xsl:for-each>


			<xsl:for-each select="Related">
				<relatedInfo>
					<titleInfo>
						<title>
							<xsl:value-of select="."/>
						</title>
					</titleInfo>
					<identifier type="local">
						<xsl:value-of select="@RelIDNumber"/>
					</identifier>
					<identifier type="URI">
						<xsl:value-of select="@RelURL"/>
					</identifier>
				</relatedInfo>
			</xsl:for-each>

		</mods>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="file://C:\Documents and Settings\ckeith\Desktop\moa2example.xml" htmlbaseurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="file://C:\Documents and Settings\ckeith\Desktop\MOA2.DTD" srcSchemaRoot="GDM" srcSchemaPathIsRelative="yes" destSchemaPath="http://www.loc.gov/standards/mods/mods.xsd" destSchemaRoot="mods" destSchemaPathIsRelative="yes" />
</metaInformation>
-->