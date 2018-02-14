<?xml version='1.0'?>

<!-- Updated 03/20/2008 to fix template error:  J. Radebaugh -->

<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:output indent="yes" encoding="UTF-8"/>

	<xsl:template match="/marc:collection">
		<validationReport>
			<xsl:apply-templates select="marc:record"/>
		</validationReport>
	</xsl:template>

	<xsl:template match="marc:record">
		<xsl:if test="count(marc:datafield[@tag=245])>1">
			<RepeatError tag="{@tag=245}"/>
		</xsl:if>
		<xsl:apply-templates select="marc:datafield[@tag=010 or @tag=040 or @tag=100 or @tag=245]"/>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=010]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesNR">a</xsl:with-param>
			<xsl:with-param name="sCodesR">bz8</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> </xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> </xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=040]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesNR">abce6</xsl:with-param>
			<xsl:with-param name="sCodesR">d8</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> </xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> </xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=100]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesNR">abdfghlqtu6</xsl:with-param>
			<xsl:with-param name="sCodesR">cejknp48</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">013</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> </xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag=245]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesNR">abcfghs6</xsl:with-param>
			<xsl:with-param name="sCodesR">knp8</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsl:template match="marc:leader">
		<InvalidLeader/>
	</xsl:template>

	<xsl:template match="marc:controlfield">
		<InvalidField tag="{@tag}"/>
	</xsl:template>

	<xsl:template match="marc:datafield">
		<InvalidField tag="{@tag}"/>
	</xsl:template>

	<xsl:template name="validateDatafield">
		<xsl:param name="sCodesNR"/>
		<xsl:param name="sCodesR"/>
		<xsl:param name="i1Values"/>
		<xsl:param name="i2Values"/>
		<xsl:call-template name="checkNRSubfields">
			<xsl:with-param name="sCodesNR" select="$sCodesNR"/>
		</xsl:call-template>
		<xsl:call-template name="validateSubfields">
			<xsl:with-param name="sCodes" select="concat($sCodesR,$sCodesNR)"/>
		</xsl:call-template>
		<xsl:call-template name="validateIndicator1">
			<xsl:with-param name="iValues" select="$i1Values"/>
		</xsl:call-template>
		<xsl:call-template name="validateIndicator2">
			<xsl:with-param name="iValues" select="$i2Values"/>
		</xsl:call-template>
	</xsl:template>

	<xsl:template name="checkNRSubfields">
		<xsl:param name="sCodesNR"/>
		<xsl:if test="$sCodesNR">
			<xsl:if test="count(marc:subfield[@code=substring($sCodesNR,1,1)])>1">
				<NonRepeatableSubFieldRepeats code="{@code}"/>
			</xsl:if>
			<xsl:call-template name="checkNRSubfields">
				<xsl:with-param name="sCodesNR" select="substring($sCodesNR,2)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template name="validateSubfields">
		<xsl:param name="sCodes"/>
		<xsl:for-each select="marc:subfield">
			<xsl:if test="not(contains($sCodes, @code))">
				<InvalidSubfield code="{@code}">
					<xsl:copy-of select=".."/>
				</InvalidSubfield>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>

	<xsl:template name="validateIndicator1">
		<xsl:param name="iValues"/>
		<xsl:if test="not(contains($iValues,@ind1))">
			<InvalidIndicator i1="{@ind1}">
				<xsl:copy-of select="."/>
			</InvalidIndicator>
		</xsl:if>
	</xsl:template>

	<xsl:template name="validateIndicator2">
		<xsl:param name="iValues"/>
		<xsl:if test="not(contains($iValues,@ind2))">
			<InvalidIndicator i2="{@ind2}">
				<xsl:copy-of select="."/>
			</InvalidIndicator>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>
