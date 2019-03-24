<?xml version="1.0"  encoding="UTF-8" ?>

<xsl:stylesheet version="1.0"
	xmlns:dam="https://www.dirk-mittenhuber.de"
	
	xmlns:x="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
	xmlns:ro="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
	xmlns:rp="http://schemas.openxmlformats.org/package/2006/relationships"
	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
	<!-- formatieren (einruecken) -->
	<xsl:output method="text" media-type="text/plain" encoding="utf-8" />
	
	<!-- text output helpers: TODO move to external file -->
	<xsl:variable name="nl" select="'&#10;'" />
	<xsl:variable name="spc" select="' '" />
	<xsl:variable name="tab" select="'&#9;'" />
	
	<xsl:variable name="lpar" select="'('" />
	<xsl:variable name="rpar" select="')'" />
	<xsl:variable name="lbra" select="'['" />
	<xsl:variable name="rbra" select="']'" />
	<xsl:variable name="lcur" select="'{'" />
	<xsl:variable name="rcur" select="'}'" />
	
	<xsl:variable name="comma" select="','" />
	<xsl:variable name="colon" select="':'" />
	<xsl:variable name="dot" select="'.'" />
	
	
	<dam:doku><![CDATA[
# Workbook

Inhaltsverzeichnis und mehr.

]]>
	</dam:doku>
	<xsl:variable name="txt.bar.100">
		<xsl:for-each select="document('')//node()[ position() &lt; 100 ]">
			<xsl:text>-</xsl:text>
		</xsl:for-each>
	</xsl:variable>
	<xsl:variable name="spc.100" select="translate($txt.bar.100,'-',' ')" />
	<xsl:variable name="txt.bar.40" select="substring($txt.bar.100,1,40)"/>
	<dam:doku><![CDATA[
Zugriff auf diverse Dokumente des Package-Containers

]]>
	</dam:doku>	
	<xsl:variable name="wb.doc" select="/" />	
	<xsl:variable name="rels.doc"
		 select="document('../_rels/.rels',           $wb.doc)" />	
	<xsl:variable name="wb.rels.doc"
		 select="document('_rels/workbook.xml.rels',  $wb.doc)" />	
	<xsl:variable name="sst.doc"
		  select="document('sharedStrings.xml',       $wb.doc)" />	
	
	<xsl:template match="/">
		<xsl:value-of select="concat(
			'Inhaltsverzeichnis', $nl,
			$txt.bar.40, $nl
			)" />
		<xsl:apply-templates select="//x:sheet" />
	</xsl:template>
	<dam:doku><![CDATA[
## Worksheet

Informationen (z.B. Umfang des Datenbereichs) nachschlagen.

Zu den besonders gewöhnungsbedürftigen Eigenheiten von ECMA-376 gehört die Tatsache,
dass im `workbook` der Namensraum `.../officeDocument/relationships`
heißt aber im `workbook.xml.rels` dann im Namensraum `.../package/relationships`
gesucht werden muss.

Hat man das einmal richtig justiert, muss man es nie wieder anschauen, und daran
sollte man sich dann auch besser halten.
]]>
		</dam:doku>
	<xsl:template match="x:sheet">
		<xsl:variable name="ws.name" select="@name" />
		<xsl:variable name="ws.id" select="@sheetId" />
		<xsl:variable name="rel.id" select="@ro:id" />
		<xsl:variable name="target" select="$wb.rels.doc//rp:Relationship[ @Id=$rel.id ]/@Target"/>
		<xsl:variable name="indent" select="substring($spc.100,1,3)"/>
		<xsl:variable name="ws.doc" select="document($target, $wb.doc )" />
		<xsl:variable name="ws.range" select="$ws.doc//x:dimension/@ref"/>
		
		<xsl:variable name="row.lo" 
			select="translate(substring-before($ws.range,$colon),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','')" />
		<xsl:variable name="row.hi" 
			select="translate(substring-after($ws.range,$colon),'ABCDEFGHIJKLMNOPQRSTUVWXYZ','')" />
		<xsl:variable name="col.hi" 
			select="translate(substring-after($ws.range,$colon),'0123456789','')" />
		<xsl:variable name="num.cells" select="count($ws.doc//x:c)" />
		
		<xsl:value-of select="concat(
			'+  ', $ws.name,$nl,
			$indent,
			$lpar,'sheet id',$colon,$spc, $ws.id,
			$spc,'rel id',$colon,$spc, $rel.id ,$rpar,
			$spc,'target',$colon,$spc,$target,$nl,
			$indent,'range',$colon, $spc, $ws.range, $comma, $spc,
			'row count', $colon, $spc, $row.hi, $comma, $spc,
			'rightmost col',$colon, $spc, $col.hi, $comma, $spc,
			'# cells', $colon, $spc, $num.cells,
			$nl
			)"/>
	</xsl:template>
</xsl:stylesheet>