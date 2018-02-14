<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:oxsl="dummy-uri">
	<xsl:namespace-alias stylesheet-prefix="oxsl" result-prefix="xsl"/>
	<xsl:output encoding="UTF-8"/>

	<xsl:template match="/">
		<oxsl:stylesheet version="1.0" exclude-result-prefixes="marc xs" xmlns:marc="http://www.loc.gov/MARC21/slim">
			<oxsl:output indent="yes" encoding="UTF-8"/>
			<oxsl:template name="validateDatafield">
				<oxsl:param name="isObselete" select="false()"/>
				<oxsl:param name="sCodesNR"/>
				<oxsl:param name="sCodesR"/>
				<oxsl:param name="i1Values"/>
				<oxsl:param name="i2Values"/>
				<oxsl:if test="$isObselete=true()">
					<warning type="ObsoleteTag">
					<oxsl:call-template name="controlNumber"/>
						<tag>
							<oxsl:value-of select="@tag"/>
						</tag>
					</warning>
				</oxsl:if>
				<oxsl:call-template name="checkNRSubfields">
					<oxsl:with-param name="sCodesNR" select="$sCodesNR"/>
				</oxsl:call-template>
				<oxsl:call-template name="validateSubfields">
					<oxsl:with-param name="sCodes" select="concat($sCodesR,$sCodesNR)"/>
				</oxsl:call-template>
				<oxsl:call-template name="validateIndicator1">
					<oxsl:with-param name="iValues" select="$i1Values"/>
				</oxsl:call-template>
				<oxsl:call-template name="validateIndicator2">
					<oxsl:with-param name="iValues" select="$i2Values"/>
				</oxsl:call-template>
			</oxsl:template>

			<oxsl:template name="checkNRSubfields">
				<oxsl:param name="sCodesNR"/>
				<oxsl:if test="$sCodesNR">
					<oxsl:if test="count(marc:subfield[@code=substring($sCodesNR,1,1)])&gt;1">
						<error type="NonRepeatableSubFieldRepeats">
							<oxsl:call-template name="controlNumber"/>
							<tag>
								<oxsl:value-of select="../@tag"/>
							</tag>
							<code>
								<xsl:value-of select="@code"/>
							</code>
						</error>
					</oxsl:if>
					<oxsl:call-template name="checkNRSubfields">
						<oxsl:with-param name="sCodesNR" select="substring($sCodesNR,2)"/>
					</oxsl:call-template>
				</oxsl:if>
			</oxsl:template>

			<oxsl:template name="validateSubfields">
				<oxsl:param name="sCodes"/>
				<oxsl:for-each select="marc:subfield">
					<oxsl:if test="not(contains($sCodes, @code))">
						<error type="InvalidSubfieldCode">
							<oxsl:call-template name="controlNumber"/>
							<tag>
								<oxsl:value-of select="../@tag"/>
							</tag>
							<code>
								<oxsl:value-of select="@code"/>
							</code>
						</error>
					</oxsl:if>
				</oxsl:for-each>
			</oxsl:template>

			<oxsl:template name="validateIndicator1">
				<oxsl:param name="iValues"/>
				<oxsl:if test="not(contains($iValues,@ind1))">
					<error type="InvalidIndicator">
						<oxsl:call-template name="controlNumber"/>
						<tag>
							<oxsl:value-of select="@tag"/>
						</tag>
						<ind1>
							<oxsl:value-of select="@ind1"/>
						</ind1>
					</error>
				</oxsl:if>
			</oxsl:template>

			<oxsl:template name="validateIndicator2">
				<oxsl:param name="iValues"/>
				<oxsl:if test="not(contains($iValues,@ind2))">
					<error type="InvalidIndicator">
						<oxsl:call-template name="controlNumber"/>
						<tag>
							<oxsl:value-of select="@tag"/>
						</tag>
						<ind2>
							<oxsl:value-of select="@ind2"/>
						</ind2>
					</error>
				</oxsl:if>
			</oxsl:template>

			<xsl:apply-templates select="xs:schema"/>
		</oxsl:stylesheet>
	</xsl:template>

	<xsl:template match="xs:schema">
		<oxsl:template match="/marc:collection">
			<validationReport>
				<oxsl:apply-templates/>
			</validationReport>
		</oxsl:template>
		<oxsl:template match="marc:record">
			<xsl:for-each select="xs:element[string-length(@name)=7]">
				<xsl:if test="xs:complexType/xs:attribute[@name='repeatable']/@fixed='no'">
					<oxsl:if test="count(marc:datafield[@tag={substring(@name,5,3)}])&gt;1">
						<error type="RepeatedTag">
							<oxsl:call-template name="controlNumber"/>
							<tag>
								<oxsl:value-of select="@tag"/>
							</tag>
						</error>
					</oxsl:if>
				</xsl:if>
			</xsl:for-each>
			<oxsl:apply-templates select="marc:datafield"/>
		</oxsl:template>

		<xsl:for-each select="xs:element[string-length(@name)=7]">
			<xsl:variable name="elementStem" select="@name"/>
			<oxsl:template match="marc:datafield[@tag={substring(@name,5,3)}]">
				<oxsl:call-template name="validateDatafield">
					<xsl:if test="xs:complexType/xs:attribute[@name='obsolete']/@fixed='yes'">
						<oxsl:with-param name="isObsolete" select="true()"/>
					</xsl:if>
					<oxsl:with-param name="sCodesR">
						<xsl:for-each select="xs:complexType/xs:choice/xs:element">
							<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>
							<xsl:variable name="attributes" select="/xs:schema/xs:element[@name=$elementName]/xs:complexType/xs:simpleContent/xs:extension"/>
							<xsl:if test="$attributes/xs:attribute[@name='repeatable']/@fixed = 'yes'">
								<xsl:value-of select="substring($elementName,9,1)"/>
							</xsl:if>
						</xsl:for-each>
					</oxsl:with-param>
					<oxsl:with-param name="sCodesNR">
						<xsl:for-each select="xs:complexType/xs:choice/xs:element">
							<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>
							<xsl:variable name="attributes" select="/xs:schema/xs:element[@name=$elementName]/xs:complexType/xs:simpleContent/xs:extension"/>
							<xsl:if test="$attributes/xs:attribute[@name='repeatable']/@fixed = 'no'">
								<xsl:value-of select="substring($elementName,9,1)"/>
							</xsl:if>
						</xsl:for-each>
					</oxsl:with-param>
					<oxsl:with-param name="sCodesO">
						<xsl:for-each select="xs:complexType/xs:choice/xs:element">
							<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>
							<xsl:variable name="attributes" select="/xs:schema/xs:element[@name=$elementName]/xs:complexType/xs:simpleContent/xs:extension"/>
							<xsl:if test="$attributes/xs:attribute[@name='obsolete']/@fixed = 'yes'">
								<xsl:value-of select="substring($elementName,9,1)"/>
							</xsl:if>
						</xsl:for-each>
					</oxsl:with-param>
					<oxsl:with-param name="i1Values" xml:space="preserve">
						<xsl:for-each select="xs:complexType/xs:attribute[@name='i1']/xs:simpleType/xs:restriction/xs:enumeration">
							<xsl:call-template name="convertIndicator">
								<xsl:with-param name="indicator" select="@value"/>
							</xsl:call-template>
						</xsl:for-each>
					</oxsl:with-param>
					<oxsl:with-param name="i2Values" xml:space="preserve">
						<xsl:for-each select="xs:complexType/xs:attribute[@name='i2']/xs:simpleType/xs:restriction/xs:enumeration">
							<xsl:call-template name="convertIndicator">
								<xsl:with-param name="indicator" select="@value"/>
							</xsl:call-template>
						</xsl:for-each>
					</oxsl:with-param>
				</oxsl:call-template>
			</oxsl:template>
		</xsl:for-each>

		<oxsl:template match="marc:datafield">
			<warning type="UnknownTag">
				<oxsl:call-template name="controlNumber"/>
				<tag>
					<oxsl:value-of select="@tag"/>
				</tag>
			</warning>
		</oxsl:template>

		<oxsl:template name="controlNumber">
			<oxsl:if test="../marc:controlfield[@tag=001]">
				<oxsl:attribute name="controlNumber">
					<oxsl:value-of select="../marc:controlfield[@tag=001]"/>
				</oxsl:attribute>
			</oxsl:if>
		</oxsl:template>
	</xsl:template>

	<xsl:template name="convertIndicator">
		<xsl:param name="indicator"/>
		<xsl:variable name="shortIndicator" select="substring($indicator,4)"/>
		<xsl:choose>
			<xsl:when test="$shortIndicator='blank'">
				<xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="$shortIndicator='fill'">
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$shortIndicator"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="no" name="mrca" userelativepaths="yes" externalpreview="no" url="mrcaxmlfileNS.xsd" htmlbaseurl="" outputurl="" processortype="msxml4" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="mrcb" userelativepaths="yes" externalpreview="no" url="mrcbxmlfile.xsd" htmlbaseurl="" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->