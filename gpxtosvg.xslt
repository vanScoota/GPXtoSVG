<?xml version="1.0" encoding="UTF-8"?>

        <!-- Namespace g für Default-Namespace der gpx-Datei -->
<xsl:stylesheet version="2.0" exclude-result-prefixes="fn xs fn_ms g"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:fn_ms="https://www.hs-aalen.de/"
        xmlns:g="http://www.topografix.com/GPX/1/1"
        xmlns="http://www.w3.org/2000/svg">

    <xsl:output method="html" encoding="UTF-8" indent="yes"/>
    
    <!-- Abmessungen der SVG-Grafik -->
    <xsl:variable name="svgWidth" select="1200"/>
    <xsl:variable name="svgHeight" select="600"/>
    
     <!-- ermittle frühesten und spätesten Zeitpunkt sowie Zeitdifferenz -->
    <xsl:variable name="minTime" select="fn:min(//g:trkpt/xs:dateTime(g:time))"/>
    <xsl:variable name="maxTime" select="fn:max(//g:trkpt/xs:dateTime(g:time))"/>
    <xsl:variable name="difTime" select="($maxTime - $minTime) div xs:dayTimeDuration('PT1S')"/>
    
    <!-- ermittle minimale und maximale Höhe sowie Höhendifferenz -->
    <xsl:variable name="minEle" select="fn:min(//g:trkpt/g:ele)"/>
    <xsl:variable name="maxEle" select="fn:max(//g:trkpt/g:ele)"/>
    <xsl:variable name="difEle" select="$maxEle - $minEle"/>
    
    <!-- ermittle minimale und maximale Breiten- und Längenangaben -->
    <!--
    <xsl:variable name="minLat" select="fn:min(//g:trkpt/@lat)"/>
    <xsl:variable name="maxLat" select="fn:max(//g:trkpt/@lat)"/>
    <xsl:variable name="minLon" select="fn:min(//g:trkpt/@lon)"/>
    <xsl:variable name="maxLon" select="fn:max(//g:trkpt/@lon)"/>
    -->
    
    <!-- berechne Maßstab für x- und y-Achse -->
    <xsl:variable name="xScale" select="$svgWidth div $difTime"/>
    <xsl:variable name="yScale" select="$svgHeight div $difEle"/>
    
    <xsl:template match="/">
        <svg>
            <xsl:attribute name="width" select="$svgWidth"/>
            <xsl:attribute name="height" select="$svgHeight"/>
            <!-- Text-Ausgaben zum Debuggen -->
            <debug>
                <xsl:value-of select="$maxEle"/>
                <xsl:text> --- </xsl:text>
                <xsl:value-of select="$minEle"/>
                <xsl:text> --- </xsl:text>
                <xsl:value-of select="$difEle"/>
                <xsl:text> --- </xsl:text>
                <xsl:value-of select="$svgHeight"/>
                <xsl:text> --- </xsl:text>
                <xsl:value-of select="$yScale"/>
                <xsl:text> --- </xsl:text>
            </debug>
            <!-- Rahmen -->
            <rect x="0" y="0" fill="none" stroke="red">
                <xsl:attribute name="width" select="$svgWidth"/>
                <xsl:attribute name="height" select="$svgHeight"/>
            </rect>
            <!-- verarbeite Punkte -->
            <xsl:apply-templates select="//g:trkpt"/>
        </svg>
    </xsl:template>

    <!-- Darstellung mit Punkten -->
    <!--
    <xsl:template match="g:trkpt">
        <circle r="1" fill="black" stroke="none">
            <xsl:attribute name="cx" select="(xs:dateTime(g:time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="cy" select="$svgHeight - (g:ele - $minEle) * $yScale"/>
        </circle>
    </xsl:template>
    -->
    
    <!-- Darstellung mit Linien -->
    <xsl:template match="g:trkpt[fn:position() != fn:last()]">
        <line fill="none" stroke="black">
            <xsl:attribute name="x1" select="(xs:dateTime(g:time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="y1" select="$svgHeight - (g:ele - $minEle) * $yScale"/>
            <xsl:attribute name="x2" select="(xs:dateTime(following-sibling::g:trkpt[1]/g:time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="y2" select="$svgHeight - (following-sibling::g:trkpt[1]/g:ele - $minEle) * $yScale"/>
        </line>
    </xsl:template>
	
</xsl:stylesheet>