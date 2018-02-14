<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:output method="xml" indent="yes" doctype-system="ftp://ftp.loc.gov/pub/marcdtd/mrcaxmlfile.dtd"/>

	<xsl:variable name="fixedFile" select="document('MARCBIGFixedPositionsA.xml')"/>

	<xsl:template match="/">
		<mrcafile>
			<xsl:apply-templates/>
		</mrcafile>
	</xsl:template>
	<xsl:template match="marc:record">
		<xsl:variable name="leader" select="marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:choose>
			<xsl:when test="$leader6 ='z'">
				<xsl:call-template name="mrca"/>
			</xsl:when>
			<!--	<xsl:when test="$leader6 ='x' or $leader6 ='v' or $leader6 ='y'">
				<xsl:call-template name="mrch"/>
			</xsl:when>
			<xsl:when test="$leader6 ='w'">
				<xsl:call-template name="mrcc"/>
			</xsl:when>
			<xsl:when test="$leader6 ='q'">
				<xsl:call-template name="mrcq"/>
			</xsl:when>-->
			<xsl:otherwise>
				<xsl:message>Leader 6 value not matched</xsl:message>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<xsl:template name="blankValue">
		<xsl:param name="value"/>
		<xsl:param name="prefix"/>
		<xsl:value-of select="$prefix"/>
		<xsl:choose>
			<xsl:when test="normalize-space($value)=''">blank</xsl:when>
			<xsl:when test="$value='|'">fill</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$value"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template name="mrca">
		<xsl:variable name="leader" select="marc:leader"/>
		<mrca format-type="ad">
			<xsl:call-template name="breakFixed">
				<xsl:with-param name="layout" select="$fixedFile/FixedPositions/leader"/>
				<xsl:with-param name="field" select="$leader"/>
				<xsl:with-param name="stem">mrcaldr-ad</xsl:with-param>
			</xsl:call-template>


			<xsl:if test="marc:controlfield[000&lt;=@tag and @tag&lt;008]">
				<mrca-control-fields>
					<xsl:apply-templates select="marc:controlfield"/>
				</mrca-control-fields>
			</xsl:if>

			<!--	<xsl:if test="marc:controlfield[@008]">
<xsl:variable name="phys" select="marc:controlField"/>
			<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField"/>
					<xsl:with-param name="field" select="$phys"/>
					<xsl:with-param name="stem">mrca008-ad</xsl:with-param>
		</xsl:call-template>
		</xsl:if>-->

			<xsl:if test="marc:datafield[10&lt;=@tag and @tag&lt;100]">
				<mrca-numbers-and-codes>
					<xsl:apply-templates select="marc:datafield[10&lt;=@tag and @tag&lt;100]"/>
				</mrca-numbers-and-codes>
			</xsl:if>

			<xsl:if test="marc:datafield[100&lt;=@tag and @tag&lt;200]">
				<mrca-headings>
					<xsl:apply-templates select="marc:datafield[100&lt;=@tag and @tag&lt;200]"/>
				</mrca-headings>
			</xsl:if>
			<xsl:if test="marc:datafield[200&lt;=@tag and @tag&lt;300]">
				<mrca-complex-see-refs>
					<xsl:apply-templates select="marc:datafield[200&lt;=@tag and @tag&lt;300]"/>
				</mrca-complex-see-refs>
			</xsl:if>
			<xsl:if test="marc:datafield[300&lt;=@tag and @tag&lt;400]">
				<mrca-complex-see-also-refs>
					<xsl:apply-templates select="marc:datafield[300&lt;=@tag and @tag&lt;400]"/>
				</mrca-complex-see-also-refs>
			</xsl:if>
			<xsl:if test="marc:datafield[400&lt;=@tag and @tag&lt;500]">
				<mrca-see-tracings>
					<xsl:apply-templates select="marc:datafield[400&lt;=@tag and @tag&lt;500]"/>
				</mrca-see-tracings>
			</xsl:if>
			<xsl:if test="marc:datafield[500&lt;=@tag and @tag&lt;600]">
				<mrca-see-also-tracings>
					<xsl:apply-templates select="marc:datafield[500&lt;=@tag and @tag&lt;600]"/>
				</mrca-see-also-tracings>
			</xsl:if>
			<xsl:if test="marc:datafield[640&lt;=@tag and @tag&lt;650]">
				<mrca-series-treatment>
					<xsl:apply-templates select="marc:datafield[640&lt;=@tag and @tag&lt;650]"/>
				</mrca-series-treatment>
			</xsl:if>
			<xsl:if test="marc:datafield[663&lt;=@tag and @tag&lt;666]">
				<mrca-refs-notes>
					<xsl:apply-templates select="marc:datafield[663&lt;=@tag and @tag&lt;666]"/>
				</mrca-refs-notes>
			</xsl:if>
			<xsl:if test="marc:datafield[667&lt;=@tag and @tag&lt;700]">
				<mrca-other-notes>
					<xsl:apply-templates select="marc:datafield[667&lt;=@tag and @tag&lt;700]"/>
				</mrca-other-notes>
			</xsl:if>
			<xsl:if test="marc:datafield[700&lt;=@tag and @tag&lt;760]">
				<mrca-est-head-link-entries>
					<xsl:apply-templates select="marc:datafield[700&lt;=@tag and @tag&lt;761]"/>
				</mrca-est-head-link-entries>
			</xsl:if>
			<xsl:if test="marc:datafield[761&lt;=@tag and @tag&lt;768]">
				<mrca-number-building-fields>
					<xsl:apply-templates select="marc:datafield[761&lt;=@tag and @tag&lt;768]"/>
				</mrca-number-building-fields>
			</xsl:if>
			<xsl:if test="marc:datafield[780&lt;=@tag and @tag&lt;=788]">
				<mrca-subdiv-head-link-entries>
					<xsl:apply-templates select="marc:datafield[780&lt;=@tag and @tag&lt;=788]"/>
				</mrca-subdiv-head-link-entries>
			</xsl:if>
			<xsl:if test="marc:datafield[856&lt;=@tag and @tag&lt;856]">
				<mrca-location>
					<xsl:apply-templates select="marc:datafield[856&lt;=@tag and @tag&lt;856]"/>
				</mrca-location>
			</xsl:if>
			<xsl:if test="marc:datafield[880&lt;=@tag and @tag&lt;=880]">
				<mrca-linkage>
					<xsl:apply-templates select="marc:datafield[850&lt;=@tag and @tag&lt;=852]"/>
				</mrca-linkage>
			</xsl:if>
		</mrca>
	</xsl:template>

	<xsl:template name="breakFixed">
		<xsl:param name="layout"/>
		<xsl:param name="field"/>
		<xsl:param name="stem"/>
		<xsl:element name="{$stem}">
			<xsl:for-each select="$layout/position">
				<xsl:variable name="elementName">
					<xsl:value-of select="$stem"/>-<xsl:choose>
						<xsl:when test="@start=@end">
							<xsl:value-of select="@start"/>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="@start"/>-<xsl:value-of select="@end"/></xsl:otherwise></xsl:choose></xsl:variable>
				<xsl:element name="{$elementName}">
					<xsl:attribute name="value">
						<xsl:call-template name="blankValue">
							<xsl:with-param name="value" select="substring($field, @start + 1, @end - @start + 1)"/>
						</xsl:call-template>
					</xsl:attribute>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>


	<!--<xsl:variable name="leader" select="../marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:variable name="typeOf008">
			<xsl:choose>
				<xsl:when test="$leader6='a' or $leader6='h'">
					<xsl:choose>
						<xsl:when test="$leader7='a' or $leader7='c' or $leader7='d' or $leader7='m'">bk</xsl:when>
						<xsl:when test="$leader7='b' or $leader7='i' or $leader7='s'">se</xsl:when>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="$leader6='t'">bk</xsl:when>
				<xsl:when test="$leader6='p' or $leader6='b'">mx</xsl:when>
				<xsl:when test="$leader6='m'">cf</xsl:when>
				<xsl:when test="$leader6='e' or $leader6='f'">mp</xsl:when>
				<xsl:when test="$leader6='g' or $leader6='k' or $leader6='o' or $leader6='r' or $leader6='n'">vm</xsl:when>
				<xsl:when test="$leader6='c' or $leader6='d' or $leader6='i' or $leader6='j'">mu</xsl:when>
				<xsl:otherwise>
					<xsl:message>Type of 008 is not defined for leader 6 = <xsl:value-of select="$leader6"/></xsl:message>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="string-length(normalize-space)">-->

	<xsl:template match="marc:controlfield[@tag='008']">
			
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrca008-ad</xsl:with-param>
				</xsl:call-template>
		
	</xsl:template>

	<xsl:template match="marc:controlfield">
		<xsl:element name="mrca{@tag}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<!--<xsl:template match="marc:adcontrolfield">
		<xsl:element name="mrca{@tag}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>-->


	<xsl:template match="marc:datafield">
		<xsl:element name="mrca{@tag}">
			<xsl:attribute name="i1">
				<xsl:call-template name="blankValue">
					<xsl:with-param name="value" select="@ind1"/>
					<xsl:with-param name="prefix">i1-</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:attribute name="i2">
				<xsl:call-template name="blankValue">
					<xsl:with-param name="value" select="@ind2"/>
					<xsl:with-param name="prefix">i2-</xsl:with-param>
				</xsl:call-template>
			</xsl:attribute>
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:subfield">
		<xsl:element name="mrca{../@tag}-{@code}">
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>
	<xsl:template match="marc:datafield[@tag='034']/marc:subfield[@code='a']">
		<xsl:element name="mrca{../@tag}-{@code}">
			<xsl:attribute name="value">
				<xsl:value-of select="text()"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Authority Short" userelativepaths="yes" externalpreview="no" url="test files\adtest2\slim.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->