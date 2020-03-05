<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:tmpl="xslt://template"
                version="1.0">

 <xsl:import href="xmlverbatim.xsl"/>

  <xsl:key match="*[@ID]" use="@ID" name="id"/>


  <xsl:output method="html"/>

<xsl:variable name="layout" select="document('profile2html.template.html')"/>
<xsl:variable name="page" select="/"/>

<xsl:template match="/">
 <xsl:apply-templates select="($layout)//*[local-name()='html']"/>
</xsl:template>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="*[@tmpl:insert='pageBody']">
<xsl:apply-templates select="$page/*[local-name()='METS_Profile']" mode="profile"/>
</xsl:template>

<xsl:template match="*[local-name()='Appendix']" mode="profile"/>

<xsl:template match="*" mode="profile">
<div class="gx">
<a href="../profile_docs/mets.profile.v1-2.html#{name()}"><xsl:value-of select="name()"/>:</a>
<xsl:for-each select="@*">
@<xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;
</xsl:for-each><br/>
<xsl:apply-templates mode="profile"/>
 <xsl:apply-templates select="key('id',@RELATEDMAT)" mode="tag_examples"/>
</div>
</xsl:template>

<xsl:template match="*[local-name()='p']" mode="profile">
<p><xsl:value-of select="."/></p>
</xsl:template>

<xsl:template match="*[local-name()='a']" mode="profile">
<a><xsl:if test="@href"><xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute></xsl:if><xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="*[local-name()='URI']" mode="profile">
<xsl:if test="text()"><div>
<a href="{.}"><xsl:value-of select="@LOCTYPE"/>: <xsl:value-of select="."/></a></div>
</xsl:if>
</xsl:template>




  <xsl:template match="*[local-name()='Appendix']" mode="tag_examples">
    <!-- <xsl:param name="req_no"/> -->
    <h6>Example <xsl:value-of select="@NUMBER"/>.</h6>
    <div class="box">
      <!-- call verbatim formatter -->
      <xsl:apply-templates select="node()" mode="xmlverb"/>
    </div>
    <br/>
    <br/>
  </xsl:template>



</xsl:stylesheet>
