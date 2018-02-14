<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet version="1.0"
	xmlns:xlink="http://www.w3.org/1999/xlink" 
	xmlns:mods="http://www.loc.gov/mods/v3"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="mods xlink" >
	<xsl:output method="html" indent="yes"/>
	<!-- 
		Version 2.0 MODS3.4 records to html Winona Salesky 
		Outputs all mods elements in a definition list with element names, attribute names and values. 
	-->

	<xsl:variable name="dictionary" select="document('http://www.loc.gov/standards/mods/modsDictionary.xml')/dictionary"/>

	<xsl:template match="/">
		<html>
			<head>
				<style type="text/css">
					dt {font-weight:bold;}
					td {vertical-align:top}
				</style>
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
	</xsl:template>

	<xsl:template match="mods:mods">
		<div>
			<xsl:apply-templates/>
		</div>
		<hr/>
	</xsl:template>

	<xsl:template match="*">
		<xsl:choose>
			<xsl:when test="child::*">
				<dl>
					<dt>
						<xsl:call-template name="longName">
							<xsl:with-param name="name">
								<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="attr"/>
					</dt>
					<dd><xsl:apply-templates/></dd>
				</dl>
			</xsl:when>
			<xsl:otherwise>
				<dl>
					<dt>
						<xsl:call-template name="longName">
							<xsl:with-param name="name">
								<xsl:value-of select="local-name()"/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:call-template name="attr"/>
					</dt>
						<xsl:call-template name="formatValue"/>
				</dl>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="formatValue">
		<dd>
			<xsl:choose>
				<xsl:when test="@type='uri'">
					<a href="{text()}">
						<xsl:value-of select="text()"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="text()"/>
				</xsl:otherwise>
			</xsl:choose>
		</dd>
	</xsl:template>

	<xsl:template name="longName">
		<xsl:param name="name"/>
		<xsl:choose>
			<xsl:when test="$dictionary/entry[@key=$name]">
				<xsl:value-of select="$dictionary/entry[@key=$name]"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="attr">
		<xsl:for-each select="@type|@point">: <xsl:call-template name="longName"><xsl:with-param name="name"><xsl:value-of select="."/></xsl:with-param></xsl:call-template></xsl:for-each>
		<xsl:if test="@authority or @edition">
			<xsl:for-each select="@authority"> (<xsl:call-template name="longName"><xsl:with-param name="name"><xsl:value-of select="."/></xsl:with-param></xsl:call-template></xsl:for-each>
			<xsl:if test="@edition"> Edition <xsl:value-of select="@edition"/></xsl:if>)</xsl:if>
		<xsl:variable name="attrStr">
			<xsl:for-each select="@*[local-name()!='edition' and local-name()!='type' and local-name()!='authority' and local-name()!='point']">
				<xsl:value-of select="local-name()"/>="<xsl:value-of select="."/>", </xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nattrStr" select="normalize-space($attrStr)"/>
		<xsl:if test="string-length($nattrStr)"> (<xsl:value-of select="substring($nattrStr,1,string-length($nattrStr)-1)"/>)</xsl:if>
	</xsl:template>
</xsl:stylesheet>
