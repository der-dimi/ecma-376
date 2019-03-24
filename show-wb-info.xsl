<?xml version="1.0"  encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:dam="https://www.dirk-mittenhuber.de"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- formatieren (einruecken) -->
	<xsl:output method="text" media-type="text/plain" encoding="utf-8" />
	
	<xsl:variable name="nl" select="'&#10;'" />
	<dam:doku><![CDATA[
# Workbook

Inhaltsverzeichnis und mehr.

]]>
	</dam:doku>
	
	<xsl:template match="/">
		<xsl:value-of select="concat(
			'Inhaltsverzeichnis', $nl
			)" />
	</xsl:template>
</xsl:stylesheet>