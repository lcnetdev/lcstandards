<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions">
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
		<!--
List of identifiers.  Used in identifier template.

This is a STARTER list.   Additional types will be added upon request.
-->
	<xsl:variable name="identifierTypeList" select="
	'identifier', 
	'isbn', 
	'lccn', 
	'hdl', 
	'doi',
	'issn'
	"/>
	

</xsl:stylesheet>
