<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet exclude-result-prefixes="marc xs" version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema">
	<xsl:output indent="yes" encoding="UTF-8"/>
	<xsl:template name="validateDatafield">
		<xsl:param name="isObselete" select="false()"/>
		<xsl:param name="sCodesNR"/>
		<xsl:param name="sCodesR"/>
		<xsl:param name="i1Values"/>
		<xsl:param name="i2Values"/>
		<xsl:if test="$isObselete=true()">
			<warning type="ObsoleteTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</warning>
		</xsl:if>
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
			<xsl:if test="count(marc:subfield[@code=substring($sCodesNR,1,1)])&gt;1">
				<error type="NonRepeatableSubFieldRepeats">
					<xsl:call-template name="controlNumber"/>
					<tag>
						<xsl:value-of select="../@tag"/>
					</tag>
					<code></code>
				</error>
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
				<error type="InvalidSubfieldCode">
					<xsl:call-template name="controlNumber"/>
					<tag>
						<xsl:value-of select="../@tag"/>
					</tag>
					<code>
						<xsl:value-of select="@code"/>
					</code>
				</error>
			</xsl:if>
		</xsl:for-each>
	</xsl:template>
	<xsl:template name="validateIndicator1">
		<xsl:param name="iValues"/>
		<xsl:if test="not(contains($iValues,@ind1))">
			<error type="InvalidIndicator">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
				<ind1>
					<xsl:value-of select="@ind1"/>
				</ind1>
			</error>
		</xsl:if>
	</xsl:template>
	<xsl:template name="validateIndicator2">
		<xsl:param name="iValues"/>
		<xsl:if test="not(contains($iValues,@ind2))">
			<error type="InvalidIndicator">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
				<ind2>
					<xsl:value-of select="@ind2"/>
				</ind2>
			</error>
		</xsl:if>
	</xsl:template>
	<xsl:template match="/marc:collection">
		<validationReport>
			<xsl:apply-templates/>
		</validationReport>
	</xsl:template>
	<xsl:template match="marc:record">
		<xsl:if test="count(marc:datafield[@tag=010])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=015])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=018])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=036])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=038])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=040])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=042])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=043])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=044])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=045])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=047])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=066])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=100])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=110])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=111])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=130])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=240])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=243])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=245])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=250])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=254])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=256])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=257])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=261])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=263])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=265])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=306])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=310])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=315])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=350])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=357])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=400])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=410])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=507])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=514])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=523])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=537])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=841])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=842])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:if test="count(marc:datafield[@tag=844])&gt;1">
			<error type="RepeatedTag">
				<xsl:call-template name="controlNumber"/>
				<tag>
					<xsl:value-of select="@tag"/>
				</tag>
			</error>
		</xsl:if>
		<xsl:apply-templates select="marc:datafield"/>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=001]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=003]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=004]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=005]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=010]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<!-- <xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param> -->
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=011]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=013]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">def8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abc6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=014]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=015]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=016]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a2</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 7</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=017]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=018]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=020]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abc6</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=022]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">yz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=024]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">acd26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123478</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=025]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=026]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abd58</xsl:with-param>
			<xsl:with-param name="sCodesNR">ce26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=027]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=028]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=030]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=032]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=033]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abc8</xsl:with-param>
			<xsl:with-param name="sCodesNR">36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=034]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bchst8</xsl:with-param>
			<xsl:with-param name="sCodesNR">adefgjkmnp6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=035]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=036]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=037]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cfgn8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=038]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=040]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">d8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abce6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=041]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcdefgh8</xsl:with-param>
			<xsl:with-param name="sCodesNR">26</xsl:with-param>
			<xsl:with-param name="sCodesO">c</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 7</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=042]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=043]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abc28</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=044]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abc28</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=045]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abc8</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=046]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdejklmn26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=047]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=048]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ab8</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=050]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ad8</xsl:with-param>
			<xsl:with-param name="sCodesNR">3b6</xsl:with-param>
			<xsl:with-param name="sCodesO">d</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01234</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=051]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abc</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=052]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcd8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a26</xsl:with-param>
			<xsl:with-param name="sCodesO">c</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 017</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=055]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=058]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">b</xsl:with-param>
			<xsl:with-param name="sCodesNR">a26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=060]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01234</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=061]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">bc</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=066]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">c</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=070]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=071]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">bc</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=072]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">x8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">07</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=073]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=074]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=080]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">x8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=082]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 04</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=084]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=086]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=088]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=100]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cejknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfglqtu6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=110]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bdeknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfgltu6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=111]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">beknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfglqtu6</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=130]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlorst6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=210]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">28</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=211]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=212]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=214]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=222]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=240]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlors6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=241]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">ah</xsl:with-param>
			<xsl:with-param name="sCodesO">ah</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=242]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">denp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abchy6</xsl:with-param>
			<xsl:with-param name="sCodesO">de</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=243]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlors6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=245]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">deknp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcfghs6</xsl:with-param>
			<xsl:with-param name="sCodesO">de</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=246]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">denp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abfghi56</xsl:with-param>
			<xsl:with-param name="sCodesO">de</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 012345678</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=247]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">denp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abfghx6</xsl:with-param>
			<xsl:with-param name="sCodesO">de</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=250]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=254]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=255]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefg6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=256]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=257]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=260]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcd8</xsl:with-param>
			<xsl:with-param name="sCodesNR">efg36</xsl:with-param>
			<xsl:with-param name="sCodesO">d</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=261]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">abdef8</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO">abdef68</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=263]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=265]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">a</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=270]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ajklmnpqrz48</xsl:with-param>
			<xsl:with-param name="sCodesNR">bcdefghi6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 12</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 07</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=300]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">acfg8</xsl:with-param>
			<xsl:with-param name="sCodesNR">be36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=301]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">abcdef</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdef</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=302]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=303]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=304]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=305]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">def</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcmn6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefmn6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=306]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=307]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=308]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">abcdef6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdef6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=310]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=311]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghmp6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=312]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcfghmp6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=315]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">ab</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO">ab6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=321]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=340]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcdefhi8</xsl:with-param>
			<xsl:with-param name="sCodesNR">36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=342]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ef8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdghijklmnopqrstuvw26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012345678</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=343]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">f8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdeghi6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=350]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">ab</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO">ab6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=351]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ab8</xsl:with-param>
			<xsl:with-param name="sCodesNR">c36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=352]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bc8</xsl:with-param>
			<xsl:with-param name="sCodesNR">adefgi6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=355]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcj8</xsl:with-param>
			<xsl:with-param name="sCodesNR">adefgh6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123458</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=357]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcg8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=362]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=400]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">ceknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfgltuvx6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefgklnptuvx468</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">013</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=410]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">bdeknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfgltuvx6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefgklnptuvx468</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=411]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">eknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfglqtuvx6</xsl:with-param>
			<xsl:with-param name="sCodesO">acdefgklnpqtuvx468</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=440]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">np8</xsl:with-param>
			<xsl:with-param name="sCodesNR">avx6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=490]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">av8</xsl:with-param>
			<xsl:with-param name="sCodesNR">lx6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=500]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">lxz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a356</xsl:with-param>
			<xsl:with-param name="sCodesO">lxz</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=501]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a56</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=502]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=503]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=504]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=505]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">grtu8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0128</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=506]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdeu8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=507]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=508]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=510]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcx36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01234</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=511]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=512]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">a</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=513]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=514]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcghjkuz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">adefim6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=515]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=516]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=517]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">bc</xsl:with-param>
			<xsl:with-param name="sCodesNR">a</xsl:with-param>
			<xsl:with-param name="sCodesO">abc</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=518]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=520]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">u8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abz36</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01238</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=521]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">b36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012348</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=522]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=523]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO">ab6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=524]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=525]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=526]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">xz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdi56</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 08</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=527]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=530]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8u</xsl:with-param>
			<xsl:with-param name="sCodesNR">63abcdz</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=531]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">b8</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdef6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=533]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcfmn8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ade367</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=534]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">fknxz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcelmpt6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=535]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcd8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ag36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=536]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdefgh8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=537]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=538]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=540]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">u8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcd356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=541]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">no8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefh356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=543]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=544]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcden8</xsl:with-param>
			<xsl:with-param name="sCodesNR">36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=545]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">u8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=546]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">b8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az36</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=547]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=550]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=552]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">efopuz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdghijklmn6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=555]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bu8</xsl:with-param>
			<xsl:with-param name="sCodesNR">acd36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 08</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=556]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=561]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">b8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a356</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=562]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcde8</xsl:with-param>
			<xsl:with-param name="sCodesNR">356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=563]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">u8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=565]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcde8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 08</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=567]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=570]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ab6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=571]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">b8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=572]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=573]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=574]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=575]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=576]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=580]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">az6</xsl:with-param>
			<xsl:with-param name="sCodesO">z</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=581]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">z8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=582]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO">a6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=583]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdefhijklnouxz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a2356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=584]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">ab8</xsl:with-param>
			<xsl:with-param name="sCodesNR">356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=585]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=586]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 8</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=587]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=600]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cejkmnpvxyz48</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfghloqrstu236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=610]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bdekmnpvxyz48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfghlorstu236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=611]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">beknpvxyz48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfghlqstu236</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=630]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnpvxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlorst236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=648]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">vxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=650]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">vxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcde236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=651]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bvxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a236</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=652]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">xyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">a</xsl:with-param>
			<xsl:with-param name="sCodesO">axyz</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=653]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=654]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcvyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=655]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcvxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a2356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=656]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">vxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ak236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">7</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=657]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">vxyz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a236</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 7</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=658]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">b8</xsl:with-param>
			<xsl:with-param name="sCodesNR">acd26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=700]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cejkmnp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfghloqrstux356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=705]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">cekmnp</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfghlorst</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefghklmnoprst</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=710]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bdekmnp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfghlorstux356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=711]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">beknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfghlqstux356</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=715]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">abekmnp</xsl:with-param>
			<xsl:with-param name="sCodesNR">fghlorstu</xsl:with-param>
			<xsl:with-param name="sCodesO">abefghklmnoprstu</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=720]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">e48</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 12</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=730]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlorstx356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=740]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">np8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ah56</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=752]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcd6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=753]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abc6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=754]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">acdxz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">26</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=755]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">xyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">a236</xsl:with-param>
			<xsl:with-param name="sCodesO">axyz236</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=760]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gnow8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=762]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gnow8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=765]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=767]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=770]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=772]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 08</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=773]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdhimpstuxy367</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=774]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 08</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=775]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0128</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=776]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=777]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknow8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=780]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01234567</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=785]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012345678</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=786]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhijmpstuvxy67</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 8</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=787]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">gknorwz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdhimqstuxy67</xsl:with-param>
			<xsl:with-param name="sCodesO">q</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">01</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=800]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">cejkmnp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfghloqrstuv6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=810]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bdekmnp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfghlorstuv6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=811]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">beknp48</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfghlqstuv6</xsl:with-param>
			<xsl:with-param name="sCodesO">b</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=830]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">dkmnp8</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlorstv6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=840]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">ahv</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO">ahv</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=841]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">abe</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=842]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=843]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcfmn8</xsl:with-param>
			<xsl:with-param name="sCodesNR">ade36</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=844]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=845]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">8</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcd356</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=850]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">a8</xsl:with-param>
			<xsl:with-param name="sCodesNR">bde</xsl:with-param>
			<xsl:with-param name="sCodesO">bde</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=851]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">abcdefg36</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefg36</xsl:with-param>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=852]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcegikmsxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">ahjlnpqt2368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012345678</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=853]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">vyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnptwx368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=854]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">uvyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnoptwx368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">0123</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=855]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">uvyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnoptwx368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=856]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcdfgimstuvwxyz</xsl:with-param>
			<xsl:with-param name="sCodesNR">hjklnopqr236</xsl:with-param>
			<xsl:with-param name="sCodesO">g</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 012347</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0128</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=863]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">sxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnpqtw68</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01234</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=864]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">sxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnopqtw68</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 01234</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=865]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">sxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">abcdefghijklmnopqtw68</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 45</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 13</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=866]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">xz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=867]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">xz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=868]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">xz8</xsl:with-param>
			<xsl:with-param name="sCodesNR">a6</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 345</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">012</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=870]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">cejknp4</xsl:with-param>
			<xsl:with-param name="sCodesNR">abdfglqtu6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefgjklnpqtu46</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">0123</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=871]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">bdejknp4</xsl:with-param>
			<xsl:with-param name="sCodesNR">acfgltu6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefgjklnptu46</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=872]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">bejknp4</xsl:with-param>
			<xsl:with-param name="sCodesNR">acdfglqtu6</xsl:with-param>
			<xsl:with-param name="sCodesO">abcdefgjklnpqtu46</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=873]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="isObsolete" select="true()"/>
			<xsl:with-param name="sCodesR">djkmnp</xsl:with-param>
			<xsl:with-param name="sCodesNR">afghlorst6</xsl:with-param>
			<xsl:with-param name="sCodesO">adfghjklmnoprst6</xsl:with-param>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve">01</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=876]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdehjlprxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">at368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=877]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdehjlprxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">at368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=878]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">bcdehjlprxz</xsl:with-param>
			<xsl:with-param name="sCodesNR">at368</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=880]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcdefghijklmnopqrstuvwxyz0123456789</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve"> 0123456789</xsl:with-param>
			<xsl:with-param name="i2Values" xml:space="preserve"> 0123456789</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=886]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR">abcdefghijklmnopqrstuvwxyz0123456789</xsl:with-param>
			<xsl:with-param name="sCodesNR"/>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values" xml:space="preserve">012</xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag=887]">
		<xsl:call-template name="validateDatafield">
			<xsl:with-param name="sCodesR"/>
			<xsl:with-param name="sCodesNR">a2</xsl:with-param>
			<xsl:with-param name="sCodesO"/>
			<xsl:with-param name="i1Values"><xsl:text> </xsl:text></xsl:with-param>
			<xsl:with-param name="i2Values"><xsl:text> </xsl:text></xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	<xsl:template match="marc:datafield">
		<warning type="UnknownTag">
			<xsl:call-template name="controlNumber"/>
			<tag>
				<xsl:value-of select="@tag"/>
			</tag>
		</warning>
	</xsl:template>
	<xsl:template name="controlNumber">
		<xsl:if test="../marc:controlfield[@tag=001]">
			<xsl:attribute name="controlNumber">
				<xsl:value-of select="../marc:controlfield[@tag=001]"/>
			</xsl:attribute>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c) 2004-2005. Progress Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="http://www.loc.gov/standards/marcxml/validation/sister.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/><scenario default="yes" name="Scenario2" userelativepaths="yes" externalpreview="no" url="file:///c:/javadev3/MARCXML/resources/chabon.xml" htmlbaseurl="" outputurl="" processortype="internal" useresolver="no" profilemode="0" profiledepth="" profilelength="" urlprofilexml="" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext="" validateoutput="no" validator="internal" customvalidator=""/></scenarios><MapperMetaTag><MapperInfo srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/><MapperBlockPosition></MapperBlockPosition><TemplateContext></TemplateContext><MapperFilter side="source"></MapperFilter></MapperMetaTag>
</metaInformation>
-->