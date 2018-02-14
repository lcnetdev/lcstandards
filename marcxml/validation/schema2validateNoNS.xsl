<?xml version='1.0'?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  xmlns:oxsl="dummy-uri">
<xsl:namespace-alias stylesheet-prefix="oxsl" result-prefix="xsl"/>
<xsl:output indent="yes"/>

<xsl:template match="/">
	<oxsl:stylesheet version="1.0" xmlns:marc="http://www.loc.gov/MARC21/slim">
		<xsl:apply-templates select="schema"/>
	</oxsl:stylesheet>
</xsl:template>

<xsl:template match="schema">
	<oxsl:template match="marc:record">
	<xsl:for-each select="element[string-length(@name)=7]">
		<xsl:if test="complexType/attribute[@name='repeatable']/@fixed='no'">
			<oxsl:if test="marc:datafield[@tag={substring(@name,5,3)}][position()>1]">
				<RepeatedField tag="{@tag}">
					<oxsl:value-of select="marc:datafield[@tag={substring(@name,5,3)}][position()>1]"/>
				</RepeatedField>
			</oxsl:if>
		</xsl:if>
	</xsl:for-each>

	<xsl:for-each select="element[string-length(@name)=7]">
		<xsl:variable name="elementStem" select="@name"/>
		<oxsl:template match="marc:datafield[@tag={substring(@name,5,3)}]">
			<oxsl:call-template name="validateDatafield">
			<xsl:if test="complexType/attribute[@name='obsolete']/@fixed='yes'">
				<oxsl:with-param name="isObsolete" select="true()"/>
			</xsl:if>
			<oxsl:with-param name="sCodesR">
			<xsl:for-each select="complexType/choice/element">
				<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>		
				<xsl:variable name="attributes" select="/schema/element[@name=$elementName]/complexType/simpleContent/extension"/>
				<xsl:if test="$attributes/attribute[@name='repeatable']/@fixed = 'yes'">
					<xsl:value-of select="substring($elementName,9,1)"/>
				</xsl:if>
			</xsl:for-each>
			</oxsl:with-param>
			<oxsl:with-param name="sCodesNR">
			<xsl:for-each select="complexType/choice/element">
				<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>		
				<xsl:variable name="attributes" select="/schema/element[@name=$elementName]/complexType/simpleContent/extension"/>
				<xsl:if test="$attributes/attribute[@name='repeatable']/@fixed = 'no'">
					<xsl:value-of select="substring($elementName,9,1)"/>
				</xsl:if>
			</xsl:for-each>
			</oxsl:with-param>
			<oxsl:with-param name="sCodesO">
			<xsl:for-each select="complexType/choice/element">
				<xsl:variable name="elementName" select="concat($elementStem,'-',substring(@ref,9,1))"/>		
				<xsl:variable name="attributes" select="/schema/element[@name=$elementName]/complexType/simpleContent/extension"/>
				<xsl:if test="$attributes/attribute[@name='obsolete']/@fixed = 'yes'">
					<xsl:value-of select="substring($elementName,9,1)"/>
				</xsl:if>
			</xsl:for-each>
			</oxsl:with-param>
			<oxsl:with-param name="i1Values" xml:space="preserve">
				<xsl:for-each select="complexType/attribute[@name='i1']/simpleType/restriction/enumeration">
					<xsl:call-template name="convertIndicator">
						<xsl:with-param name="indicator" select="@value"/>
					</xsl:call-template>
				</xsl:for-each>
			</oxsl:with-param>
			<oxsl:with-param name="i2Values" xml:space="preserve">
				<xsl:for-each select="complexType/attribute[@name='i2']/simpleType/restriction/enumeration">
					<xsl:call-template name="convertIndicator">
						<xsl:with-param name="indicator" select="@value"/>
					</xsl:call-template>
				</xsl:for-each>
			</oxsl:with-param>
			</oxsl:call-template>
		</oxsl:template>
	</xsl:for-each>
	<oxsl:apply-templates select="marc:datafield[@tag=010 or @tag=040 or @tag=100 or @tag=245]"/>
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

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2001 eXcelon Corp.
<metaInformation>
<scenarios ><scenario default="no" name="mrca" userelativepaths="yes" url="mrcaxmlfile.xsd" htmlbaseurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="mrcb" userelativepaths="yes" url="mrcbxmlfile.xsd" htmlbaseurl="" processortype="msxml4" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo  srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" />
</metaInformation>
-->