<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:outputxsl="dummy-uri">
<xsl:output method="xml" indent="yes"/>
<xsl:namespace-alias stylesheet-prefix="outputxsl" result-prefix="xsl"/>

<xsl:template match="MarcFields">
	<outputxsl:stylesheet version="1.0" xmlns="http://www.loc.gov/MARC" xmlns:xsi="http://www.w3.org/1999/XSL/Transform">
		<xsl:apply-templates select="Field"/>
	</outputxsl:stylesheet>
</xsl:template>

<xsl:template match="Field">
	<xsl:element name="xsl:template">
		<xsl:attribute name="match">dataField[@tag=<xsl:value-of select="@tag"/>]</xsl:attribute>
		<p><xsl:value-of select="text()"/></p>
		<ul>
		<xsl:for-each select="Subfield">
			<xsl:element  name="xsl:for-each">
				<xsl:attribute name="select">subfield[@code='<xsl:value-of select="@code"/>']</xsl:attribute>
				<li><xsl:value-of select="text()"/>:
				<xsl:element name="xsl:value-of"><xsl:attribute name="select">text()</xsl:attribute></xsl:element>
				</li>
			</xsl:element>
		</xsl:for-each>
		</ul>
	</xsl:element>
</xsl:template>

</xsl:stylesheet>
