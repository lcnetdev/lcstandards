<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format">
<xsl:output method="html"/>

<xsl:template match="MarcFields">
	<html>
		<table>
			<xsl:apply-templates select="Field"/>
		</table>
	</html>
</xsl:template>

<xsl:template match="Field">
	<tr>
		<td>
			<xsl:value-of select="@tag"/>
		</td>
		<td>
			<xsl:value-of select="text()"/>
		</td>
	</tr>
	<xsl:apply-templates select="Subfield"/>
</xsl:template>

<xsl:template match="Subfield">
	<tr>
		<td>
			<xsl:value-of select="@code"/>
		</td>
		<td>
			<xsl:value-of select="."/>
		</td>
	</tr>
</xsl:template>

</xsl:stylesheet>
