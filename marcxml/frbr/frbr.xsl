<?xml version='1.0'?>
<xsl:stylesheet version="2.0" xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<xsl:import href="MARC21slim2FullRecord.xsl"/>
<xsl:include href="../xslt/MARC21slimUtils.xsl"/>

<xsl:template match="/marc:collection">
	<html>
		<ul>
		<xsl:for-each-group select="marc:record" group-by="marc:datafield[@tag=100]">
			<xsl:sort select="marc:datafield[@tag=100]"/>
			<li>
			<xsl:call-template name="chopPunctuation">
				<xsl:with-param name="chopString">
					<xsl:value-of select="marc:datafield[@tag=100]"/>
				</xsl:with-param>
			</xsl:call-template>
			<br/>
			<xsl:for-each-group select="current-group()" group-by="normalize-space(
										translate(
											substring(
														marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245]/marc:subfield[@code='a'],
														marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245]/@ind2
											),
										'abcdefghijklmnopqrstuvwxyz,.;/-:',
										'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
									))">
				<xsl:call-template name="chopPunctuation">
					<xsl:with-param name="chopString" select="normalize-space(translate(marc:datafield[@tag=130 or @tag=240 or @tag=243 or @tag=245]/marc:subfield[@code='a'],',.;/',''))"/>
				</xsl:call-template>
				<ul>
				<xsl:for-each-group select="current-group()" group-by="concat(substring(marc:leader,7,1),substring(marc:controlfield[@tag=008],36,3))">
					<li>
						<xsl:variable name="leader6" select="substring(marc:leader,7,1)"/>
						<xsl:choose>
							<xsl:when test="$leader6='a' or $leader6='t'">Text</xsl:when> 
							<xsl:when test="$leader6='e' or $leader6='f'">Cartographic</xsl:when> 
							<xsl:when test="$leader6='c' or $leader6='d'">Notated Music</xsl:when> 
							<xsl:when test="$leader6='i' or $leader6='j'">Sound Recording</xsl:when> 
							<xsl:when test="$leader6='k'">Still Image</xsl:when> 
							<xsl:when test="$leader6='g'">Moving Image</xsl:when> 
							<xsl:when test="$leader6='r'">Three Dimensional Object</xsl:when> 
							<xsl:when test="$leader6='m'">Software, Multimedia</xsl:when> 
							<xsl:when test="$leader6='p'">Mixed Material</xsl:when> 
							<xsl:otherwise>LDR6=<xsl:value-of select="$leader6"/></xsl:otherwise>
						</xsl:choose>
						<!--
						<xsl:variable name="languages" select="document('http://www.loc.gov/standards/iso639-2/langcodes.xml')/languages"/>
						<xsl:value-of select="$languages/language[@ISO639-2=$langauge]/@English"/>
						-->
						<xsl:variable name="language" select="substring(marc:controlfield[@tag=008],36,3)"/>
						<xsl:variable name="longLanguage">
							<xsl:choose>
								<xsl:when test="$language='eng'">English</xsl:when>
								<xsl:when test="$language='ita'">Italian</xsl:when>
								<xsl:when test="$language='ger'">German</xsl:when>
								<xsl:when test="$language='und'">Undetermined</xsl:when>
								<xsl:when test="$language='ara'">Arabic</xsl:when>
								<xsl:when test="$language='lat'">Latin</xsl:when>
								<xsl:when test="$language='fre'">French</xsl:when>
								<xsl:when test="$language='dan'">Danish</xsl:when>
								<xsl:when test="$language='spa'">Spanish</xsl:when>
								<xsl:when test="$language='mon'">Mongolian</xsl:when>
								<xsl:when test="$language='mar'">Marathi</xsl:when>
								<xsl:when test="$language='hin'">Hindi</xsl:when>
								<xsl:when test="$language='swe'">Swedish</xsl:when>
								<xsl:when test="$language='pol'">Polish</xsl:when>
								<xsl:when test="$language='rus'">Russian</xsl:when>
								<xsl:when test="$language='kan'">Kannada</xsl:when>
								<xsl:when test="$language='|||'"></xsl:when>
								<xsl:when test="$language='   '"></xsl:when>
								<xsl:otherwise>008/35-37=<xsl:value-of select="$language"/></xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:if test="normalize-space($longLanguage)">
						- <xsl:value-of select="$longLanguage"/>
						</xsl:if>
						<ul>
							<li>
							<xsl:for-each select="marc:datafield[@tag=245]">
								<xsl:call-template name="chopPunctuation">
									<xsl:with-param name="chopString">
										<xsl:call-template name="subfieldSelect">
											<xsl:with-param name="codes">a</xsl:with-param>
										</xsl:call-template>
									</xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
							</li>
							<ul>
								<xsl:for-each select="current-group()">
									<li><a href="#{generate-id(.)}">Edition:
										<xsl:for-each select="marc:datafield[@tag=250]">
											<xsl:call-template name="subfieldSelect">
												<xsl:with-param name="codes">ab</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
										</a>
									</li>
									<ul>
										<xsl:for-each select="marc:datafield[@tag=245][marc:subfield[@code='b']]">
											<li>Subtitle:
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:call-template name="subfieldSelect">
															<xsl:with-param name="codes">b</xsl:with-param>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</li>
										</xsl:for-each>
										<xsl:for-each select="marc:datafield[@tag=245][marc:subfield[@code='c']]">
											<li>Statement of responsiblity:
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:call-template name="subfieldSelect">
															<xsl:with-param name="codes">c</xsl:with-param>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</li>
										</xsl:for-each>
										<xsl:for-each select="marc:datafield[@tag=260]">
											<li>Imprint:
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:call-template name="subfieldSelect">
															<xsl:with-param name="codes">bc</xsl:with-param>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</li>
										</xsl:for-each>
										<li>Physical description: 
											<xsl:call-template name="chopPunctuation">
												<xsl:with-param name="chopString">
													<xsl:value-of select="marc:datafield[@tag=300]"/>
												</xsl:with-param>
											</xsl:call-template>
										</li>	
										<xsl:for-each select="marc:datafield[@tag=020]/marc:subfield[@code='a']">
											<li>ISBN: 
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:value-of select="."/>
													</xsl:with-param>
												</xsl:call-template>
											</li>	
										</xsl:for-each>
										<xsl:for-each select="marc:datafield[@tag=022]/marc:subfield[@code='a']">
											<li>ISSN: 
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:value-of select="."/>
													</xsl:with-param>
												</xsl:call-template>
											</li>	
										</xsl:for-each>
										<xsl:for-each select="marc:datafield[@tag=028]">
											<li>Publisher number: 
												<xsl:call-template name="chopPunctuation">
													<xsl:with-param name="chopString">
														<xsl:call-template name="subfieldSelect">
															<xsl:with-param name="codes">ab</xsl:with-param>
														</xsl:call-template>
													</xsl:with-param>
												</xsl:call-template>
											</li>	
										</xsl:for-each>
										<xsl:for-each select="marc:datafield[@tag=533]">
											<li>Reproduction: 
													<xsl:value-of select="."/>
											</li>	
										</xsl:for-each>
									</ul>
								</xsl:for-each>
							</ul>
						</ul>
					</li>
				</xsl:for-each-group>
				</ul>
			</xsl:for-each-group>
			</li>
		</xsl:for-each-group>
		</ul>

		<xsl:for-each select="marc:record">
		<hr/>
			<DIV ID="#{generate-id(.)}">
				<xsl:apply-templates select="."/>
			</DIV>
		</xsl:for-each>
	</html>
</xsl:template>

</xsl:stylesheet><!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="yes" name="Scenario3" userelativepaths="yes" externalpreview="no" url="eudorawelty.xml" htmlbaseurl="" outputurl="" processortype="custom" commandline="java  &#x2D;jar C:\saxon7&#x2D;1\saxon7.jar &#x2D;o %3 %1 %2" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->