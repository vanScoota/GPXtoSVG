<?xml version="1.0" encoding="UTF-8"?>

		<!-- Namespace g für Default-Namespace der gpx-Datei -->
		<!-- Angabe von Namespace xmlns:fn="http://www.w3.org/2005/xpath-functions" nicht notwendig -->
<xsl:stylesheet version="2.0" exclude-result-prefixes="xs fn_ms g"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:fn_ms="https://www.hs-aalen.de/"
		xmlns:g="http://www.topografix.com/GPX/1/1"
		xmlns="http://www.w3.org/2000/svg">

	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes"/>
	
	<!-- ermittle minimale und maximale Breiten- und Längenangaben -->
	<xsl:variable name="minLat" select="min(//g:trkpt/@lat)"/>
	<xsl:variable name="maxLat" select="max(//g:trkpt/@lat)"/>
	<xsl:variable name="minLon" select="min(//g:trkpt/@lon)"/>
	<xsl:variable name="maxLon" select="max(//g:trkpt/@lon)"/>
	
	<xsl:template match="/">
		<svg>
			<bandana>
				<xsl:value-of select="$minLat"/>
				<xsl:text> --- </xsl:text>
				<xsl:value-of select="$minLon"/>
			</bandana>
			<xsl:apply-templates select="//g:trkpt"/>
		</svg>
	</xsl:template>

	<xsl:template match="g:trkpt">
		<circle r="1" fill="black">
			<xsl:attribute name="cx" select="(@lat - $minLat) * 1000"/>
			<xsl:attribute name="cy" select="(@lon - $minLon) * 1000"/>
		</circle>
	</xsl:template>
	
</xsl:stylesheet>