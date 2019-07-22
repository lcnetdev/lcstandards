<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<xsl:output method="html"/>
	
	<xsl:template match="/marc:collection">
		<html>
			<xsl:apply-templates select="marc:record[1]"/>
		</html>
	</xsl:template>
	
	<xsl:template match="marc:record">
		<table>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">LC Control Number:</xsl:with-param>
					<xsl:with-param name="tag">010</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Personal Name:</xsl:with-param>
					<xsl:with-param name="tag">100</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Main Title:</xsl:with-param>
					<xsl:with-param name="tag">245</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Published/Created:</xsl:with-param>
					<xsl:with-param name="tag">260</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">ISBN:</xsl:with-param>
					<xsl:with-param name="tag">020</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Subjects:</xsl:with-param>
					<xsl:with-param name="tag">650</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="tag">651</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Genre/Form:</xsl:with-param>
					<xsl:with-param name="tag">655</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">LC Classification:</xsl:with-param>
					<xsl:with-param name="tag">050</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Dewey Class No.:</xsl:with-param>
					<xsl:with-param name="tag">082</xsl:with-param>
			</xsl:call-template>
			<xsl:call-template name="makeRow">
					<xsl:with-param name="label">Geog. Area Code:</xsl:with-param>
					<xsl:with-param name="tag">043</xsl:with-param>
			</xsl:call-template>
		</table>
	</xsl:template>
	
	<xsl:template name="makeRow">
		<xsl:param name="label"/>
		<xsl:param name="tag"/>
		<xsl:param name="codes"/>
		<xsl:if test="marc:datafield[@tag=$tag]">
		<TR>
			<TH NOWRAP="TRUE" ALIGN="RIGHT" VALIGN="TOP"><xsl:value-of select="$label"/></TH>
			<TD>
				<xsl:for-each select="marc:datafield[@tag=$tag]">
					<xsl:value-of select="."/>
					<br/>
				</xsl:for-each>
			</TD>
		</TR>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" url="sister.xml" htmlbaseurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->