<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="marc">
	<xsl:output method="xml" indent="yes" doctype-system="ftp://ftp.loc.gov/pub/marcdtd/mrcbxmlfile.dtd"/>

	<xsl:variable name="fixedFile" select="document('MARCBIGFixedPositions.xml')"/>
	<xsl:template match="/">
	<mrcbfile>
		<xsl:apply-templates/>
	</mrcbfile>
	</xsl:template>

	<xsl:template match="marc:record">
		<xsl:variable name="leader" select="marc:leader"/>
		<xsl:variable name="leader6" select="substring($leader,7,1)"/>
		<xsl:variable name="leader7" select="substring($leader,8,1)"/>
		<xsl:choose>
			<xsl:when test="$leader6 ='z'">
				<!--<xsl:call-template name="mrca"/>-->
			</xsl:when>
			<xsl:when test="$leader6 ='x' or $leader6 ='v' or $leader6 ='y'">
				<!--<xsl:call-template name="mrch"/>-->
			</xsl:when>
			<xsl:when test="$leader6 ='w'">
				<!--<xsl:call-template name="mrcc"/>-->
			</xsl:when>
			<xsl:when test="$leader6 ='q'">
				<!--<xsl:call-template name="mrcq"/>-->
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="mrcb"/>
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

	<xsl:template name="mrcb">
		<xsl:variable name="leader" select="marc:leader"/>
		<mrcb format-type="bd">
			<xsl:call-template name="breakFixed">
				<xsl:with-param name="layout" select="$fixedFile/FixedPositions/leader"/>
				<xsl:with-param name="field" select="$leader"/>
				<xsl:with-param name="stem">mrcbldr-bd</xsl:with-param>
			</xsl:call-template>
			<mrcb-control-fields>
				<xsl:apply-templates select="marc:controlfield"/>
			</mrcb-control-fields>
			<xsl:if test="marc:datafield[10&lt;=@tag and @tag&lt;100]">
				<mrcb-numbers-and-codes>
					<xsl:apply-templates select="marc:datafield[10&lt;=@tag and @tag&lt;100]"/>
				</mrcb-numbers-and-codes>
			</xsl:if>
			<xsl:if test="marc:datafield[100&lt;=@tag and @tag&lt;200]">
				<mrcb-main-entry>
					<xsl:apply-templates select="marc:datafield[100&lt;=@tag and @tag&lt;200]"/>
				</mrcb-main-entry>
			</xsl:if>
			<xsl:if test="marc:datafield[200&lt;=@tag and @tag&lt;250]">
				<mrcb-title-and-title-related>
					<xsl:apply-templates select="marc:datafield[200&lt;=@tag and @tag&lt;250]"/>
				</mrcb-title-and-title-related>
			</xsl:if>
			<xsl:if test="marc:datafield[250&lt;=@tag and @tag&lt;300]">
				<mrcb-edition-imprint-etc>
					<xsl:apply-templates select="marc:datafield[250&lt;=@tag and @tag&lt;300]"/>
				</mrcb-edition-imprint-etc>
			</xsl:if>
			<xsl:if test="marc:datafield[300&lt;=@tag and @tag&lt;400]">
				<mrcb-physical-description>
					<xsl:apply-templates select="marc:datafield[300&lt;=@tag and @tag&lt;400]"/>
				</mrcb-physical-description>
			</xsl:if>
			<xsl:if test="marc:datafield[400&lt;=@tag and @tag&lt;500]">
				<mrcb-series-statement>
					<xsl:apply-templates select="marc:datafield[400&lt;=@tag and @tag&lt;500]"/>
				</mrcb-series-statement>
			</xsl:if>
			<xsl:if test="marc:datafield[500&lt;=@tag and @tag&lt;600]">
				<mrcb-notes>
					<xsl:apply-templates select="marc:datafield[500&lt;=@tag and @tag&lt;600]"/>
				</mrcb-notes>
			</xsl:if>
			<xsl:if test="marc:datafield[600&lt;=@tag and @tag&lt;700]">
				<mrcb-subject-access>
					<xsl:apply-templates select="marc:datafield[600&lt;=@tag and @tag&lt;700]"/>
				</mrcb-subject-access>
			</xsl:if>
			<xsl:if test="marc:datafield[700&lt;=@tag and @tag&lt;760]">
				<mrcb-added-entry>
					<xsl:apply-templates select="marc:datafield[700&lt;=@tag and @tag&lt;760]"/>
				</mrcb-added-entry>
			</xsl:if>
			<xsl:if test="marc:datafield[760&lt;=@tag and @tag&lt;800]">
				<mrcb-linking-entry>
					<xsl:apply-templates select="marc:datafield[760&lt;=@tag and @tag&lt;800]"/>
				</mrcb-linking-entry>
			</xsl:if>
			<xsl:if test="marc:datafield[800&lt;=@tag and @tag&lt;=840]">
				<mrcb-series-added-entry>
					<xsl:apply-templates select="marc:datafield[800&lt;=@tag and @tag&lt;=840]"/>
				</mrcb-series-added-entry>
			</xsl:if>
			<xsl:if test="marc:datafield[841&lt;=@tag and @tag&lt;845]">
				<mrcb-holdings-notes>
					<xsl:apply-templates select="marc:datafield[841&lt;=@tag and @tag&lt;845]"/>
				</mrcb-holdings-notes>
			</xsl:if>
			<xsl:if test="marc:datafield[850&lt;=@tag and @tag&lt;=852]">
				<mrcb-location>
					<xsl:apply-templates select="marc:datafield[850&lt;=@tag and @tag&lt;=852]"/>
				</mrcb-location>
			</xsl:if>
			<xsl:if test="marc:datafield[853&lt;=@tag and @tag&lt;=855]">
				<mrcb-captions-and-patterns>
					<xsl:apply-templates select="marc:datafield[853&lt;=@tag and @tag&lt;=855]"/>
				</mrcb-captions-and-patterns>
			</xsl:if>
			<xsl:if test="marc:datafield[@tag=856]">
				<mrcb-access>
					<xsl:apply-templates select="marc:datafield[@tag=856]"/>
				</mrcb-access>
			</xsl:if>
			<xsl:if test="marc:datafield[863&lt;=@tag and @tag&lt;=865]">
				<mrcb-enumeration-and-chron>
					<xsl:apply-templates select="marc:datafield[863&lt;=@tag and @tag&lt;=865]"/>
				</mrcb-enumeration-and-chron>
			</xsl:if>
			<xsl:if test="marc:datafield[866&lt;=@tag and @tag&lt;=868]">
				<mrcb-textual-holdings>
					<xsl:apply-templates select="marc:datafield[866&lt;=@tag and @tag&lt;=868]"/>
				</mrcb-textual-holdings>
			</xsl:if>
			<xsl:if test="marc:datafield[870&lt;=@tag and @tag&lt;=873]">
				<mrcb-variant-names>
					<xsl:apply-templates select="marc:datafield[870&lt;=@tag and @tag&lt;=873]"/>
				</mrcb-variant-names>
			</xsl:if>
			<xsl:if test="marc:datafield[876&lt;=@tag and @tag&lt;=878]">
				<mrcb-item-information>
					<xsl:apply-templates select="marc:datafield[876&lt;=@tag and @tag&lt;=878]"/>
				</mrcb-item-information>
			</xsl:if>
			<xsl:if test="marc:datafield[880&lt;=@tag and @tag&lt;=886]">
				<mrcb-linkages>
					<xsl:apply-templates select="marc:datafield[880&lt;=@tag and @tag&lt;=886]"/>
				</mrcb-linkages>
			</xsl:if>
		</mrcb>
	</xsl:template>

	<xsl:template name="breakFixed">
		<xsl:param name="layout"/>
		<xsl:param name="field"/>
		<xsl:param name="stem"/>
		<xsl:element name="{$stem}">
			<xsl:for-each select="$layout/position">
				<xsl:variable name="elementName">
					<xsl:value-of select="$stem"/>-<xsl:choose><xsl:when test="@start=@end"><xsl:value-of select="@start"/></xsl:when><xsl:otherwise><xsl:value-of select="@start"/>-<xsl:value-of select="@end"/></xsl:otherwise></xsl:choose></xsl:variable>
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


	<xsl:template match="marc:controlfield[@tag='008']">
		<xsl:variable name="leader" select="../marc:leader"/>
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
		<xsl:if test="string-length(normalize-space($typeOf008))">
			<xsl:call-template name="breakFixed">
				<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='008'][@typeOfRecord=$typeOf008]"/>
				<xsl:with-param name="field" select="text()"/>
				<xsl:with-param name="stem" select="concat('mrcb008-',$typeOf008)"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="marc:controlfield[@tag='006']">
		<xsl:variable name="typeOf006" select="substring(text(),1,1)"/>
		<xsl:choose>
			<xsl:when test="$typeOf006='e' or $typeOf006='f'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-mp</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='a' or $typeOf006='t'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-bk</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='c' or $typeOf006='d' or $typeOf006='i' or $typeOf006='j'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-mu</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='m'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-cf</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='p'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-mx</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='s'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-se</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
			<xsl:when test="$typeOf006='g' or $typeOf006='k' or $typeOf006='o' or $typeOf006='r'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='006'][contains(@typeOfRecord,$typeOf006)]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem">mrcb006-vm</xsl:with-param>
				</xsl:call-template>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="marc:controlfield[@tag='007']">
		<xsl:variable name="typeOf007" select="substring(text(),1,1)"/>
		<xsl:variable name="elementName">mrcb007-<xsl:value-of select="substring(text(),1,1)"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="$typeOf007='h' or $typeOf007='c' or $typeOf007='m' or $typeOf007='r' or $typeOf007='f'">
				<xsl:call-template name="breakFixed">
					<xsl:with-param name="layout" select="$fixedFile/FixedPositions/controlField[@tag='007'][@typeOfRecord=$typeOf007]"/>
					<xsl:with-param name="field" select="text()"/>
					<xsl:with-param name="stem" select="$elementName"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:element name="{$elementName}">
					<xsl:call-template name="make007">
						<xsl:with-param name="restOf007" select="text()"/>
						<xsl:with-param name="prefix" select="$elementName"/>
					</xsl:call-template>
				</xsl:element>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="make007">
		<xsl:param name="restOf007"/>
		<xsl:param name="charPos">0</xsl:param>
		<xsl:param name="prefix"/>
		<xsl:if test="not($restOf007='')">
			<xsl:variable name="charPos2">
				<xsl:choose>
					<xsl:when test="$charPos&lt;=9">0<xsl:value-of select="$charPos"/></xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$charPos"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:element name="{$prefix}-{$charPos2}">
				<xsl:attribute name="value">
					<xsl:call-template name="blankValue">
						<xsl:with-param name="value" select="substring($restOf007,1,1)"/>
					</xsl:call-template>
				</xsl:attribute>
			</xsl:element>
			<xsl:call-template name="make007">
				<xsl:with-param name="restOf007" select="substring($restOf007,2)"/>
				<xsl:with-param name="charPos" select="$charPos+1"/>
				<xsl:with-param name="prefix" select="$prefix"/>
			</xsl:call-template>
		</xsl:if>
	</xsl:template>

	<xsl:template match="marc:controlfield">
		<xsl:element name="mrcb{@tag}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="marc:datafield">
		<xsl:element name="mrcb{@tag}">
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
		<xsl:element name="mrcb{../@tag}-{@code}">
			<xsl:value-of select="text()"/>
		</xsl:element>
	</xsl:template>

	<xsl:template match="marc:datafield[@tag='034']/marc:subfield[@code='a']">
		<xsl:element name="mrcb{../@tag}-{@code}">
			<xsl:attribute name="value">
				<xsl:value-of select="text()"/>
			</xsl:attribute>
		</xsl:element>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario1" userelativepaths="yes" externalpreview="no" url="..\..\..\..\..\..\CVS\marc4j\dist\lib\test4.xml" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->