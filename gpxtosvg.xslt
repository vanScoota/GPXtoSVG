<?xml version="1.0" encoding="UTF-8"?>

        <!-- xpath-default-namespace für Default-Namespace der GraphHopper-Datei -->
        <!-- xpath-default-namespace="http://www.topografix.com/GPX/1/1" -->
<xsl:stylesheet version="2.0" exclude-result-prefixes="fn xs math fn_ms"
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:fn="http://www.w3.org/2005/xpath-functions"
        xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:math="http://exslt.org/math"
        xmlns:fn_ms="https://www.hs-aalen.de/"
        xmlns="http://www.w3.org/2000/svg"
        xpath-default-namespace="http://www.topografix.com/GPX/1/1"
>
    
    <xsl:output method="xml" encoding="UTF-8" indent="yes"/>
    
    <!-- Abmessungen der SVG-Grafik -->
    <xsl:variable name="svgWidth" select="1200"/>
    <xsl:variable name="svgHeight" select="600"/>
    
     <!-- ermittle frühesten und spätesten Zeitpunkt sowie Zeitdifferenz -->
    <xsl:variable name="minTime" select="fn:min(//trkpt/xs:dateTime(time))"/>
    <xsl:variable name="maxTime" select="fn:max(//trkpt/xs:dateTime(time))"/>
    <xsl:variable name="difTime" select="($maxTime - $minTime) div xs:dayTimeDuration('PT1S')"/>
    
    <!-- ermittle minimale und maximale Höhe sowie Höhendifferenz -->
    <xsl:variable name="minEle" select="fn:min(//trkpt/ele)"/>
    <xsl:variable name="maxEle" select="fn:max(//trkpt/ele)"/>
    <xsl:variable name="difEle" select="$maxEle - $minEle"/>
    
    <!-- ermittle minimale und maximale Breiten- und Längenangaben -->
    <!--
    <xsl:variable name="minLat" select="fn:min(//trkpt/@lat)"/>
    <xsl:variable name="maxLat" select="fn:max(//trkpt/@lat)"/>
    <xsl:variable name="minLon" select="fn:min(//trkpt/@lon)"/>
    <xsl:variable name="maxLon" select="fn:max(//trkpt/@lon)"/>
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
            </debug>
            <!-- Rahmen -->
            <rect x="0" y="0" fill="none" stroke="red">
                <xsl:attribute name="width" select="$svgWidth"/>
                <xsl:attribute name="height" select="$svgHeight"/>
            </rect>
            <!-- verarbeite Segmente -->
            <xsl:apply-templates select="//trkseg"/>
        </svg>
    </xsl:template>
    
    <xsl:template match="trkseg">
        <xsl:choose>
            <!-- mehrere trkseg - übergebe zufällige Farbe an alle Kindknoten -->
            <xsl:when test="preceding-sibling::trkseg | following-sibling::trkseg">
                <xsl:apply-templates select="child::trkpt[fn:position() != fn:last()]">
                    <xsl:with-param name="color" select="fn_ms:random-color()"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- einzelnes trkseg - übergebe keine Farbe -->
            <xsl:otherwise>
                <xsl:apply-templates select="child::trkpt[fn:position() != fn:last()]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <!-- Darstellung mit Linien -->
    <xsl:template match="trkpt">
        <!-- wird keine Farbe übergeben, erstelle zufällige Farbe -->
        <xsl:param name="color" select="fn_ms:random-color()"/>
        <line fill="none">
            <xsl:attribute name="stroke" select="$color"/>
            <xsl:attribute name="x1" select="(xs:dateTime(time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="y1" select="$svgHeight - (ele - $minEle) * $yScale"/>
            <xsl:attribute name="x2" select="(xs:dateTime(following-sibling::trkpt[1]/time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="y2" select="$svgHeight - (following-sibling::trkpt[1]/ele - $minEle) * $yScale"/>
        </line>
    </xsl:template>
    
    <!-- erstelle zufälligen RGB-Farbcode -->
    <xsl:function name="fn_ms:random-color">
        <xsl:sequence select="
            fn:concat (
                'rgb(',
                xs:integer(math:random() * 256) mod 256,
                ', ',
                xs:integer(math:random() * 256) mod 256,
                ', ',
                xs:integer(math:random() * 256) mod 256,
                ')')"/>
    </xsl:function>
    
    <!-- Darstellung mit Punkten -->
    <!--
    <xsl:template match="trkpt">
        <circle r="1" fill="black" stroke="none">
            <xsl:attribute name="cx" select="(xs:dateTime(time) - $minTime) div xs:dayTimeDuration('PT1S') * $xScale"/>
            <xsl:attribute name="cy" select="$svgHeight - (ele - $minEle) * $yScale"/>
        </circle>
    </xsl:template>
    -->
	
    <!-- erstelle zufälligen, hexadezimalen Farbcode -->
    <!--
    <xsl:function name="fn_ms:random-hex-color" as="xs:string">
        <xsl:sequence select="
            fn:concat (
                '#',
                fn_ms:int-to-hex (
                    xs:decimal(math:random() * 16777216) mod 16777216
                )
            )
        "/>
    </xsl:function>
    -->
    
    <!-- wandle Dezimalzahl in Hexadezimalzahl um -->
    <!--
    <xsl:function name="fn_ms:int-to-hex" as="xs:string">
        <xsl:param name="input" as="xs:decimal"/>
        <xsl:sequence select="
            if ($input eq 0) then
                '0'
            else
                fn:concat (
                    if ($input gt 16) then
                        fn_ms:int-to-hex($input idiv 16)
                    else
                        '',
                        fn:substring (
                            '0123456789ABCDEF',
                            ($input mod 16) + 1,
                            1
                        )
                )
        "/>
    </xsl:function>
    -->
    
</xsl:stylesheet>