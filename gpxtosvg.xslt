<?xml version="1.0"?>

		<!-- Namespace g für Default-Namespace der gpx-Datei -->
<xsl:stylesheet version="2.0" exclude-result-prefixes="fn xs fn_ms g"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:fn="http://www.w3.org/2005/xpath-functions"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:fn_ms="https://www.hs-aalen.de/"
		xmlns:g="http://www.topografix.com/GPX/1/1"
		xmlns="http://www.w3.org/2000/svg">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<xsl:template match="/">
		<svg>
			<banana>
				<xsl:value-of select="fn_ms_getMinLat"/></banana>
			<xsl:apply-templates select="//g:trkpt"/>
		</svg>
	</xsl:template>

	<xsl:template match="g:trkpt">
		<circle r="1" fill="black">
			<xsl:attribute name="cx" select="(@lat - 49.9) * 100"/>
			<xsl:attribute name="cy" select="(@lon - 11.5) * 100"/>
		</circle>
	</xsl:template>
	
	<xsl:function name="fn_ms:add" as="xs:integer">
		<xsl:param name="a" as="xs:integer"/>
		<xsl:param name="b" as="xs:integer"/>
		<xsl:value-of select="$a+$b"/>
	</xsl:function>
	
	<xsl:function name="fn_ms:getMinLat" as="xs:integer">
		<xsl:sequence select="fn:min((1, 2))"/>
	</xsl:function>
	
	<xsl:template name="banana">
		<xsl:value-of select="fn_ms:add(5, 7)"/>
	</xsl:template>
	
</xsl:stylesheet>