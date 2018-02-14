<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:mods="http://www.loc.gov/mods/v3" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="xlink mods">
	<xsl:output method="html" indent="yes"/>
	<xsl:include href="http://www.loc.gov/marcxml/xslt/MARC21slimUtils.xsl"/>
	<!--
	Adapted from minerva.xsl (web archive 2002) for 107th Congress site
	or any Minerva project with MODSv3 records
	
	MODIFICATION LOG 

		5/6/04   suppressed punctuation in nameparts
		4/5/04   fixed names to print all parts (inc termsOfAddress, corp names
			     add recordID, suppress Alt-title label if no data
		12/22/03 modified for MODSv3 records 	
		12/24/03 should work for all minerva if modsv3	
	-->
	<xsl:variable name="languages" select="document('http://www.loc.gov/standards/mods/lang.xml')/languages"/>
	<xsl:variable name="collName" select="/mods:mods/mods:relatedItem[@type='host']/mods:titleInfo/mods:title"/>
	<xsl:variable name="title" select="/mods:mods/mods:titleInfo[not(@type='alternative')]/mods:title"/>
	<xsl:variable name="altTitle" select="/mods:mods/mods:titleInfo[@type='alternative']/mods:title"/>
	<xsl:template match="/mods:mods">
		<html>
			<head>
				<title>Bibliographic Information Display (107th Congress Web Archive: MINERVA: Library of Congress)</title>
				<link href="/natlib/minerva/web/107th/107th.css" rel="stylesheet" type="text/css"/>
				<meta name="keywords" content="bibliographic information display search results 107th congress minerva web archive library congress"/>
				<meta name="description" content="Bibliographic Information Display: Search Results (107th Congress Web Archive: MINERVA: Library of Congress)."/>
				<!--				<meta name="keywords">
					<xsl:attribute name="content">
						<xsl:for-each select="mods:subject">
							<xsl:call-template name="keywordSubjects"/>
						</xsl:for-each>
					</xsl:attribute>
				</meta>
				<meta name="description">
					<xsl:attribute name="content">
						<xsl:value-of select="mods:abstract"/>
					</xsl:attribute>
				</meta>
				
				<title>			
					<xsl:value-of select="concat($collName,' Record - ', $title)"/>
				</title>		
-->
			</head>
			<body>
				<table cellSpacing="5" cellPadding="7" width="90%" border="0">
					<tr>
						<td colspan="2">
							<h1>
								<xsl:value-of select="mods:relatedItem[@type='host']/mods:titleInfo/mods:title"/>
							</h1>
						</td>
					</tr>
					<!--<tr>
						<td colspan="2">
							<form action="/cocoon/minerva/search" name="keyword" id="keyword">
								<strong>You searched: <input value="" size="50" type="text" name="query"/> <input value="Go!" type="submit" name="submit"/></strong>
							</form>
						</td>
					</tr>-->
					<tr>
						<td>&lt;&lt; <a href="javascript:history.go(-1)">Back</a>
						</td>
						<td align="right">[ <a href="{mods:location/mods:url[translate(@displayLabel,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')='ARCHIVED SITE']/text()}">Display Archived Web Site</a> ]</td>
					</tr>
					<tr>
						<td colspan="2" class="search-row-a">
							<table width="100%" cellpadding="4" cellspacing="2" class="search-row-a">
								<tr valign="top">
									<th width="24%">Title:</th>
									<td width="76%" align="left">
										<xsl:choose>
											<xsl:when test="$title">
												<!--title found -->
												<xsl:value-of select="$title"/>
											</xsl:when>
											<xsl:otherwise>
												<xsl:value-of select="$altTitle"/>
											</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<xsl:if test="$altTitle and $title">
									<!-- only display alternate when there is a title; otherwise, alternate is in the "title" area. -->
									<tr valign="top">
										<th>Alternative Title:</th>
										<td align="left">
											<xsl:value-of select="$altTitle"/>
										</td>
									</tr>
								</xsl:if>
								<!-- 107 'if' added -->
								<xsl:if test="mods:name">
									<tr valign="top">
										<th>Name(s):</th>
										<td align="left">
											<xsl:for-each select="mods:name">
												<b>
													<!-- all nameparts -->
													<xsl:choose>
														<xsl:when test="@type='corporate'">
															<xsl:variable name="names">
																<xsl:for-each select="mods:namePart">
																	<xsl:call-template name="chopPunctuation">
																		<xsl:with-param name="chopString">
																			<xsl:value-of select="."/>
																		</xsl:with-param>
																	</xsl:call-template>
																	<xsl:text>.  </xsl:text>
																</xsl:for-each>
															</xsl:variable>
															<xsl:value-of select="normalize-space($names)"/>
														</xsl:when>
														<xsl:otherwise>
															<xsl:value-of select="mods:namePart"/>
														</xsl:otherwise>
													</xsl:choose>
												</b>
												<br/>
											</xsl:for-each>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="mods:abstract">
									<tr valign="top">
										<th>Abstract:</th>
										<td align="left">
											<xsl:value-of select="mods:abstract"/>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="mods:originInfo/mods:place">
									<tr valign="top">
										<th>OriginInfo:</th>
										<td align="left">
											<xsl:if test="/mods:mods/@version">
												<xsl:value-of select="mods:originInfo/mods:place/mods:placeTerm[@type='text']"/>
											</xsl:if>
											<xsl:if test="not(/mods:mods/@version)">
												<xsl:value-of select="mods:originInfo/mods:place/mods:text"/>
											</xsl:if>
											<xsl:text>&#160;:&#160;</xsl:text>
											<xsl:value-of select="mods:originInfo/mods:publisher"/>
											<xsl:text>,&#160;</xsl:text>
											<xsl:value-of select="mods:originInfo/mods:dateIssued"/>
											<br/>
										</td>
									</tr>
								</xsl:if>
								
								<tr valign="top">
									<th>Date Captured:</th>
									<td align="left">
										<xsl:apply-templates select="mods:originInfo/mods:dateCaptured"/>
										<br/>
										<a href="{mods:location/mods:url[translate(@displayLabel,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')='ARCHIVED SITE']/text()}">Archived Site</a>
									</td>
								</tr>
								
								<xsl:if test="mods:subject[not(mods:hierarchicalGeographic) and not(@authority='keyword')]">
									<tr valign="top">
										<th>Subject(s):</th>
										<td align="left">
											<xsl:apply-templates select="mods:subject[not(mods:hierarchicalGeographic) and not(@authority='keyword')]"/>
										</td>
									</tr>
								</xsl:if>
								
								<xsl:if test="mods:subject/mods:hierarchicalGeographic">
									<tr valign="top">
										<td vAlign="top" align="right">Geographic Location:</td>
										<td align="left">
											<xsl:apply-templates select="mods:subject/mods:hierarchicalGeographic"/>
										</td>
									</tr>
								</xsl:if>
								<xsl:if test="mods:classification[@authority='lcc']">
									<tr valign="top">
										<th>LC Classification:</th>
										<td align="left">
											<xsl:apply-templates select="mods:classification"/>
										</td>
									</tr>
								</xsl:if>
								<tr valign="top">
									<th>Language(s):</th>
									<td align="left">
										<xsl:for-each select="mods:language/mods:languageTerm[@type='code']">
											<xsl:variable name="lang" select="."/>
											<xsl:value-of select="$languages/language[@ISO639-2=$lang]/@English"/>
											<br/>
										</xsl:for-each>
									</td>
								</tr>
								<tr valign="top">
									<th>Genre:</th>
									<td align="left">
										<xsl:value-of select="mods:genre"/>
									</td>
								</tr>
								<tr valign="top">
									<th>Access Condition:</th>
									<td align="left">
										<xsl:choose>
											<xsl:when test="mods:accessCondition/text()">
												<xsl:value-of select="mods:accessCondition"/>
											</xsl:when>
											<xsl:otherwise>None</xsl:otherwise>
										</xsl:choose>
									</td>
								</tr>
								<tr valign="top">
									<th>Active Site:</th>
									<td align="left">
										<xsl:value-of select="mods:location/mods:url[translate(@displayLabel,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')='ACTIVE SITE (IF AVAILABLE)']"/>
										<!--<xsl:value-of select="$location/locName[translate(@display,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')='ACTIVE SITE (IF AVAILABLE)']"/>-->
									</td>
								</tr>
								<xsl:if test="mods:recordInfo/mods:recordIdentifier">
									<tr valign="top">
										<th>RecordID:</th>
										<td align="left">
											<xsl:value-of select="mods:recordInfo/mods:recordIdentifier"/>
										</td>
									</tr>
								</xsl:if>
								<tr valign="top">
									<th>Collection Title:</th>
									<td align="left">
										<a href="{mods:relatedItem[@type='host']/mods:location/mods:url}">
											<xsl:value-of select="$collName"/>
										</a>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="mods:originInfo/mods:dateCaptured">
		<xsl:call-template name="parseISO8601">
			<xsl:with-param name="date" select="self::mods:dateCaptured[@encoding='iso8601']"/>
		</xsl:call-template>
		<xsl:if test="following-sibling::mods:dateCaptured[@encoding='iso8601'][@point='end']">
			<xsl:text> - </xsl:text>
		</xsl:if>
	</xsl:template>
	<xsl:template match="mods:subject[@authority!='keyword']">
		<xsl:variable name="subjects">
			<xsl:for-each select="*">
				<xsl:apply-templates select="."/>--</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nsubjects" select="normalize-space($subjects)"/>
		<xsl:value-of select="substring($nsubjects,1,string-length($nsubjects)-2)"/>
		<br/>
	</xsl:template>
	<xsl:template name="keywordSubjects">
		<xsl:variable name="metaSubjects">
			<xsl:for-each select="*">
				<xsl:apply-templates select="."/>
				<xsl:text>--</xsl:text>
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nsubjects" select="normalize-space($metaSubjects)"/>
		<xsl:value-of select="substring($nsubjects,1,string-length($nsubjects)-2)"/>
		<xsl:text>;</xsl:text>
	</xsl:template>
	<xsl:template match="mods:name">
		<!-- 107 name/date needs comma -->
		<xsl:variable name="name">
			<xsl:for-each select="*">
				<xsl:choose>
					<xsl:when test="parent::mods:name[@type='personal'] and following-sibling::mods:namePart[@type='date']">
						<xsl:value-of select="."/>
						<xsl:text>,&#160;</xsl:text>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="chopPunctuation">
							<xsl:with-param name="chopString">
								<xsl:value-of select="."/>
							</xsl:with-param>
						</xsl:call-template>
						<xsl:text>.&#160;</xsl:text>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="substring($name,1,string-length($name)-2)"/>
		<br/>
	</xsl:template>
	<xsl:template match="mods:hierarchicalGeographic">
		<xsl:variable name="subjects">
			<xsl:for-each select="*">
				<xsl:value-of select="."/>--</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="nsubjects" select="normalize-space($subjects)"/>
		<xsl:value-of select="substring($nsubjects,1,string-length($nsubjects)-2)"/>
		<br/>
	</xsl:template>
	<xsl:template name="parseISO8601">
		<xsl:param name="date"/>
		<xsl:variable name="yearN" select="substring($date,1,4)"/>
		<xsl:variable name="monthN" select="substring($date,5,2)"/>
		<xsl:variable name="dayN" select="substring($date,7,2)"/>
		<xsl:choose>
			<xsl:when test="$monthN=01">January</xsl:when>
			<xsl:when test="$monthN=02">February</xsl:when>
			<xsl:when test="$monthN=03">March</xsl:when>
			<xsl:when test="$monthN=04">April</xsl:when>
			<xsl:when test="$monthN=05">May</xsl:when>
			<xsl:when test="$monthN=06">June</xsl:when>
			<xsl:when test="$monthN=07">July</xsl:when>
			<xsl:when test="$monthN=08">August</xsl:when>
			<xsl:when test="$monthN=09">September</xsl:when>
			<xsl:when test="$monthN=10">October</xsl:when>
			<xsl:when test="$monthN=11">November</xsl:when>
			<xsl:when test="$monthN=12">December</xsl:when>
		</xsl:choose>
		<xsl:text> </xsl:text>
		<xsl:value-of select="number($dayN)"/>, <xsl:value-of select="$yearN"/>
	</xsl:template>
</xsl:stylesheet>
<!-- Stylus Studio meta-information - (c)1998-2003 Copyright Sonic Software Corporation. All rights reserved.
<metaInformation>
<scenarios ><scenario default="no" name="Scenario1" userelativepaths="yes" externalpreview="no" url="http://lcweb2.loc.gov/cocoon/minerva/0480/mods.xml" htmlbaseurl="http://lcweb2.loc.gov/cocoon/minerva/0477/default.html" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/><scenario default="yes" name="Scenario2" userelativepaths="yes" externalpreview="no" url="file://n:\minerva\iraqdone\mrva0003.0229.xml" htmlbaseurl="http://lcweb2.loc.gov/cocoon/minerva/" outputurl="" processortype="internal" commandline="" additionalpath="" additionalclasspath="" postprocessortype="none" postprocesscommandline="" postprocessadditionalpath="" postprocessgeneratedext=""/></scenarios><MapperInfo srcSchemaPath="" srcSchemaRoot="" srcSchemaPathIsRelative="yes" srcSchemaInterpretAsXML="no" destSchemaPath="" destSchemaRoot="" destSchemaPathIsRelative="yes" destSchemaInterpretAsXML="no"/>
</metaInformation>
-->
