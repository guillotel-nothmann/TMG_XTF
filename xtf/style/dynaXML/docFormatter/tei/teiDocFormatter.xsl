<xsl:stylesheet exclude-result-prefixes="#all" extension-element-prefixes="session" version="2.0" xmlns="http://www.w3.org/1999/xhtml" xmlns:session="java:org.cdlib.xtf.xslt.Session" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xtf="http://cdlib.org/xtf">
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!-- dynaXML Stylesheet                                                     -->
   <!-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ -->
   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimdiver.
      - Redistributions in binary form must reproduce the above copyright 
      notice, this list of conditions and the following disclaimer in the 
      documentation and/or other materials provided with the distribution.
      - Neither the name of the University of California nor the names of its
      contributors may be used to endorse or promote products derived from 
      this software without specific prior written permission.
      
      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" 
      AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE 
      IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE 
      ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE 
      LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR 
      CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF 
      SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS 
      INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN 
      CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) 
      ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
      POSSIBILITY OF SUCH DAMAGE.
   -->
   <!-- ====================================================================== -->
   <!-- Import Common Templates                                                -->
   <!-- ====================================================================== -->
   <xsl:import href="../common/docFormatterCommon.xsl" />
   <xsl:import href="parallelEdition.xsl" />
   <!-- ====================================================================== -->
   <!-- Output Format                                                          -->
   <!-- ====================================================================== -->
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" encoding="UTF-8" exclude-result-prefixes="#all" indent="no" media-type="text/html; charset=UTF-8" method="xhtml" omit-xml-declaration="yes" />
   <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Frameset//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd" encoding="UTF-8" exclude-result-prefixes="#all" indent="no" media-type="text/html; charset=UTF-8" method="xhtml" name="frameset" omit-xml-declaration="yes" />
   <!-- ====================================================================== -->
   <!-- Strip Space                                                            -->
   <!-- ====================================================================== -->
   <xsl:strip-space elements="*" />
   <xsl:preserve-space elements="*:p" />
   <!-- ====================================================================== -->
   <!-- Included Stylesheets                                                   -->
   <!-- ====================================================================== -->
   <xsl:include href="autotoc.xsl" />
   <xsl:include href="component.xsl" />
   <xsl:include href="search.xsl" />
   <xsl:include href="parameter.xsl" />
   <xsl:include href="structure.xsl" />
   <xsl:include href="table.xsl" />
   <xsl:include href="titlepage.xsl" />
   <xsl:include href="edit.xsl" />
   <xsl:include href="criticalApp.xsl" />
   <!-- ====================================================================== -->
   <!-- Define Keys                                                            -->
   <!-- ====================================================================== -->
   <xsl:key match="*[matches(name(), '^pb$|^milestone$')]" name="pb-id" use="@*:id" />
   <xsl:key match="*[matches(name(), '^ref$')]" name="ref-id" use="@*:id" />
   <xsl:key match="*[matches(name(), '^person$|^personGrp$|^place$|^item$|^bibl$')]" name="note-id" use="@*:id" />
   <xsl:key match="*[matches(name(), '^div')]" name="div-id" use="@*:id" />
   <!--   <xsl:key name="generic-id"
      match="*[matches(name(),'^note$')][not(@type='footnote' or @place='foot' or @type='endnote' or @place='end')]|*[matches(name(),'^figure$|^bibl$|^table$')]"
      use="@*:id"/>-->
   <xsl:key match="//*:rs" name="index" use="substring(@ref, 2)" />
   <!-- all rs  -->
   <xsl:key match="//*:quote" name="quotes" use="substring(@corresp, 2)" />
   <!-- all quotes in text -->
   <xsl:key match="//*:bibl" name="bibl" use="@xml:id" />
   <xsl:key match="//*:biblScope" name="biblScope" use="@xml:id" />
   <!-- ====================================================================== -->
   <!-- TEI-specific parameters                                                -->
   <!-- ====================================================================== -->
   <!-- If a query was specified but no particular hit rank, jump to the first hit 
      (in document order) 
   -->
   <xsl:param name="hit.rank">
      <xsl:choose>
         <xsl:when test="$query and not($query = '0')">
            <xsl:value-of select="key('hit-num-dynamic', '1')/@rank" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'0'" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <!-- To support direct links from snippets, the following two parameters must check value of $hit.rank -->
   <xsl:param name="chunk.id">
      <xsl:choose>
         <xsl:when test="$hit.rank != '0' and key('hit-rank-dynamic', $hit.rank)/ancestor::*[matches(name(), '^div')]">
            <xsl:value-of select="key('hit-rank-dynamic', $hit.rank)/ancestor::*[matches(local-name(), '^div')][1]/@*:id" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'0'" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <xsl:param name="toc.id">
      <xsl:choose>
         <xsl:when test="$hit.rank != '0' and key('hit-rank-dynamic', $hit.rank)/ancestor::*[matches(name(), '^div')]">
            <xsl:value-of select="key('hit-rank-dynamic', $hit.rank)/ancestor::*[matches(local-name(), '^div')][1]/parent::*/@*:id" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:value-of select="'0'" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:param>
   <!-- ====================================================================== -->
   <!-- Root Template                                                          -->
   <!-- ====================================================================== -->
   <xsl:template match="/">
      <xsl:choose>
         <!-- robot solution -->
         <xsl:when test="matches($http.user-agent, $robots)">
            <xsl:call-template name="robot" />
         </xsl:when>
         <xsl:when test="$doc.view = 'bbar'">
            <xsl:call-template name="bbar" />
         </xsl:when>
         <xsl:when test="$doc.view = 'toc'">
            <xsl:call-template name="toc" />
         </xsl:when>
         <xsl:when test="$doc.view = 'content'">
            <xsl:call-template name="content" />
         </xsl:when>
         <xsl:when test="$doc.view = 'popup'">
            <xsl:call-template name="popup" />
         </xsl:when>
         <xsl:when test="$doc.view = 'localentry'">
            <xsl:call-template name="localentry" />
         </xsl:when>
         <xsl:when test="$doc.view = 'citation'">
            <xsl:call-template name="citation" />
         </xsl:when>
         <xsl:when test="$doc.view = 'print'">
            <xsl:call-template name="print" />
         </xsl:when>
         <xsl:when test="$doc.view = 'edit'">
            <xsl:call-template name="edit" />
         </xsl:when>
         <xsl:when test="$doc.view = 'help'">
            <xsl:call-template name="help" />
         </xsl:when>
         <xsl:when test="$doc.view = 'coocurrence'">
            <xsl:call-template name="coocurrence" />
         </xsl:when>
         <xsl:otherwise>
            <xsl:call-template name="frames" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Frames Template                                                        -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="frames">
      <xsl:variable name="bbar.href"><xsl:value-of select="$query.string" />&#038;doc.view=bbar&#038;chunk.id=<xsl:value-of select="$chunk.id" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" /><xsl:value-of select="$search" /></xsl:variable>
      <xsl:variable name="toc.href"><xsl:value-of select="$query.string" />&#038;doc.view=toc&#038;chunk.id=<xsl:value-of select="$chunk.id" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&#038;toc.id=<xsl:value-of select="$toc.id" /><xsl:value-of select="$search" />#X</xsl:variable>
      <xsl:variable name="content.href"><xsl:value-of select="$query.string" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$chunk.id" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&#038;anchor.id=<xsl:value-of select="$anchor.id" /><xsl:value-of select="$search" /><xsl:call-template name="create.anchor" /></xsl:variable>
      <xsl:variable name="edit.href"><xsl:value-of select="$query.string" />&#038;doc.view=edit;chunk.id=<xsl:value-of select="$chunk.id" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&#038;anchor.id=<xsl:value-of select="$anchor.id" />#<xsl:value-of select="$anchor.id" /></xsl:variable>
      <xsl:result-document exclude-result-prefixes="#all" format="frameset">
         <html lang="fr" xml:lang="fr">
            <head>
               <title>
                  <xsl:value-of select="$doc.title" />
               </title>
               <link href="icons/default/favicon.ico" rel="shortcut icon" />
            </head>
            <frameset rows="149px,*">
               <frame frameborder="0" scrolling="no" title="Navigation Bar">
                  <xsl:attribute name="name">bbar</xsl:attribute>
                  <xsl:attribute name="src"><xsl:value-of select="$xtfURL" />view?<xsl:value-of select="$bbar.href" /></xsl:attribute>
               </frame>
               <frameset cols="29%,71%" id="mainframe">
                  <frameset rows="50%,50%">
                     <frame frameborder="0" title="Table of Contents">
                        <xsl:attribute name="name">toc</xsl:attribute>
                        <xsl:attribute name="src"><xsl:value-of select="$xtfURL" />view?<xsl:value-of select="$toc.href" /></xsl:attribute>
                     </frame>
                     <frame frameborder="0" title="Edition">
                        <xsl:attribute name="name">edit</xsl:attribute>
                        <xsl:choose>
                           <xsl:when test="contains($http.referer, 'index')">
                              <!-- index généré dynamiquement -->
                              <!--    <xsl:attribute name="src"><xsl:value-of select="$xtfURL"
                                 />view?<xsl:value-of select="$edit.href"/></xsl:attribute>-->
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:attribute name="src">
                                 <xsl:value-of select="$doc.dir" />index/index.html</xsl:attribute>
                              <!--  <xsl:attribute name="src"><xsl:value-of select="$xtfURL"
                              />view?<xsl:value-of select="$edit.href"/></xsl:attribute>-->
                           </xsl:otherwise>
                        </xsl:choose>
                     </frame>
                  </frameset>
                  <frame frameborder="0" id="contentframe" name="content" title="Content">
                     <xsl:attribute name="name">content</xsl:attribute>
                     <xsl:attribute name="src"><xsl:value-of select="$xtfURL" />view?<xsl:value-of select="$content.href" /></xsl:attribute>
                  </frame>
               </frameset>
               <noframes>
                  <body>
                     <h1>Sorry, your browser doesn't support frames...</h1>
                  </body>
               </noframes>
            </frameset>
         </html>
      </xsl:result-document>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Anchor Template                                                        -->
   <!-- ====================================================================== -->
   <xsl:template name="create.anchor">
      <xsl:choose>
         <!-- First so it takes precedence over computed hit.rank -->
         <xsl:when test="($query != '0' and $query != '') and $set.anchor != '0'">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="$set.anchor" />
         </xsl:when>
         <!-- Next is hit.rank -->
         <xsl:when test="($query != '0' and $query != '') and $hit.rank != '0'">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="key('hit-rank-dynamic', $hit.rank)/@hitNum" />
         </xsl:when>
         <xsl:when test="($query != '0' and $query != '') and $chunk.id != '0'">
            <xsl:text>#</xsl:text>
            <xsl:value-of select="key('div-id', $chunk.id)/@xtf:firstHit" />
         </xsl:when>
         <xsl:when test="$anchor.id != '0'">
            <xsl:text>#X</xsl:text>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>#X</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- TOC Template                                                           -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="toc">
      <xsl:call-template name="translate">
         <xsl:with-param name="resultTree">
            <html lang="en" xml:lang="en">
               <head>
                  <title>
                     <xsl:value-of select="$doc.title" />
                  </title>
                  <link href="{$css.path}toc.css" rel="stylesheet" type="text/css" />
                  <link href="icons/default/favicon.ico" rel="shortcut icon" />
               </head>
               <body>
                  <div class="toc">
                     <xsl:call-template name="book.autotoc" />
                  </div>
               </body>
            </html>
         </xsl:with-param>
      </xsl:call-template>
   </xsl:template>
   <!-- Critical App -->
   <!-- ====================================================================== -->
   <!-- Content Template                                                       -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="content">
      <xsl:variable name="navbar">
         <xsl:call-template name="navbar" />
      </xsl:variable>
      <html lang="en" xml:lang="en">
         <head>
            <title>content</title>
            <link href="{$css.path}{$content.css}" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
            <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.3/jquery.min.js" />
            <script src="http://www.verovio.org/javascript/latest/verovio-toolkit.js" />
            <link href="{$css.path}tmg-content.css" rel="stylesheet" type="text/css" />
            <script src="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.js" />
            <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Two+Tone" rel="stylesheet" />
            <link href="https://unpkg.com/material-components-web@latest/dist/material-components-web.min.css" rel="stylesheet" />
         </head>
         <body>
            <aside class="mdc-drawer mdc-drawer--modal">
               <div class="mdc-drawer__content">
                  <xsl:call-template name="getEdit" />
               </div>
            </aside>
            <div class="mdc-drawer-scrim" />
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
               <!-- BEGIN MIDNAV ROW -->
               <tr>
                  <td align="center" colspan="2" valign="top" width="100%">
                     <!-- BEGIN MIDNAV INNER TABLE -->
                     <table border="0" cellpadding="0" cellspacing="0" width="94%">
                        <tr>
                           <td colspan="3">
                              <xsl:text>&#160;</xsl:text>
                           </td>
                        </tr>
                        <xsl:copy-of select="$navbar" />
                        <tr>
                           <td colspan="3">
                              <hr class="hr-title" />
                           </td>
                        </tr>
                     </table>
                     <!-- END MIDNAV INNER TABLE -->
                  </td>
               </tr>
               <!-- END MIDNAV ROW -->
            </table>
            <!-- BEGIN CONTENT ROW -->
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
               <tr>
                  <td align="left" valign="top">
                     <div class="content">
                        <!-- BEGIN CONTENT -->
                        <xsl:choose>
                           <xsl:when test="//*:interpretation//*:item[@n = 'parallelEdition']">
                              <xsl:choose>
                                 <xsl:when test="$chunk.id = '0'">
                                    <xsl:apply-templates select="/*/*:text/*:front/*:titlePage" />
                                 </xsl:when>
                                 <xsl:when test="$chunk.id = 'criticalApp'">
                                    <xsl:call-template name="criticalApp" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:variable name="colII" select="substring(key('div-id', $chunk.id)/@corresp, 2)" />
                                    <table border="0" cellpadding="0" cellspacing="0">
                                       <xsl:apply-templates select="key('div-id', $chunk.id)" />
                                       <xsl:if test="//*:note[@type = 'footnote']">
                                          <xsl:call-template name="footnoteParallelEdition" />
                                       </xsl:if>
                                    </table>
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:choose>
                                 <xsl:when test="$chunk.id = '0'">
                                    <xsl:apply-templates select="/*/*:text/*:front/*:titlePage" />
                                 </xsl:when>
                                 <xsl:otherwise>
                                    <xsl:message><xsl:value-of select="$chunk.id"/></xsl:message>
                                    <xsl:apply-templates select="key('div-id', $chunk.id)" />
                                 </xsl:otherwise>
                              </xsl:choose>
                           </xsl:otherwise>
                        </xsl:choose>
                     </div>
                  </td>
               </tr>
               <xsl:if test="key('div-id', $chunk.id)//*:note[@type = 'footnote'] and not(//@xml:lang = 'la')">
                  <!-- se référer à une condition dans le header -->
                  <tr>
                     <td align="left" valign="top">
                        <div class="content">
                           <table border="1" cellpadding="0" cellspacing="0">
                              <xsl:call-template name="footnote" />
                           </table>
                        </div>
                     </td>
                  </tr>
               </xsl:if>
            </table>
            <table border="0" cellpadding="0" cellspacing="0" width="100%">
               <!-- BEGIN MIDNAV ROW -->
               <tr>
                  <td align="center" colspan="2" valign="top" width="100%">
                     <!-- BEGIN MIDNAV INNER TABLE -->
                     <table border="0" cellpadding="0" cellspacing="0" width="94%">
                        <tr>
                           <td colspan="3">
                              <hr class="hr-title" />
                           </td>
                        </tr>
                        <xsl:copy-of select="$navbar" />
                        <tr>
                           <td colspan="3">
                              <xsl:text>&#160;</xsl:text>
                           </td>
                        </tr>
                     </table>
                     <!-- END MIDNAV INNER TABLE -->
                  </td>
               </tr>
               <!-- END MIDNAV ROW -->
            </table>
            <script src="/xtf/style/dynaXML/docFormatter/tei/tmg-content.js" />
            <script>
            function openPopUp(popupid, url) {
               var popup = document.getElementById(popupid);
               popup.classList.toggle("show");
               $.get(url, function(data) {
                  popup.innerHTML = data;
               });
            }
            </script>
         </body>
      </html>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Print Template                                                  -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="print">
      <html lang="en" xml:lang="en">
         <head>
            <title>
               <xsl:value-of select="$doc.title" />
            </title>
            <link href="{$css.path}{$content.css}" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body bgcolor="white">
            <hr class="hr-title" />
            <div align="center">
               <table width="95%">
                  <tr>
                     <td>
                        <xsl:choose>
                           <xsl:when test="$chunk.id != '0'">
                              <xsl:apply-templates select="key('div-id', $chunk.id)" />
                           </xsl:when>
                           <xsl:otherwise>
                              <xsl:apply-templates select="/*/*:text/*" />
                           </xsl:otherwise>
                        </xsl:choose>
                     </td>
                  </tr>
               </table>
            </div>
            <hr class="hr-title" />
         </body>
      </html>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Coocurrence template                                              -->
   <!-- ====================================================================== -->
   <xsl:template name="coocurrence">
      <xsl:variable name="notes" select="document(concat($index.path, 'index.xml'))//*:bibl" />
      <xsl:variable name="mainDocPath">
         <xsl:value-of select="$doc.adress" />
      </xsl:variable>
      <xsl:variable name="mainDocViewPath">
         <xsl:value-of select="$doc.path" />
      </xsl:variable>
      <xsl:variable name="mainDoc" select="document($mainDocPath)" />
      <html lang="en" xml:lang="en">
         <head>
            <title>
               <xsl:text>Thesaurus</xsl:text>
            </title>
            <link href="{$css.path}{$content.css}" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body>
            <div class="content">
               <xsl:apply-templates select="key('note-id', $chunk.id)" />
               <table border="1">
                  <xsl:variable name="root">
                     <xsl:apply-templates mode="text-only" select="$mainDoc" />
                  </xsl:variable>
                  <xsl:for-each select="$mainDoc//*:rs[@ref = concat('#', $chunk.id)]">
                     <xsl:variable name="positionRs" select="position()" />
                     <xsl:variable name="target" select="@target" />
                     <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
                     <xsl:variable name="refchunk" select="ancestor::*:div1/@xml:id" />
                     <xsl:variable name="href">
                        <a style="color:brown; text-decoration:none" target="content">
                           <xsl:attribute name="href">
                              <xsl:value-of select="$mainDocViewPath" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&amp;#<xsl:value-of select="$anchor" /></xsl:attribute>
                           <xsl:value-of select="preceding::*:pb[1]/@n" />
                        </a>
                     </xsl:variable>
                     <!-- context (in chars) to display -->
                     <xsl:variable name="context" select="200" />
                     <!-- string before node -->
                     <xsl:variable name="stringBefore">
                        <xsl:value-of select="$root/node()[not(preceding::*:rsId[@xml:id = $positionRs])]" />
                     </xsl:variable>
                     <!-- string after node -->
                     <xsl:variable name="stringAfter">
                        <xsl:value-of select="$root/node()[preceding::*:rsId[@xml:id = $positionRs]]" />
                     </xsl:variable>
                     <xsl:variable name="nbCharBefore" select="string-length($stringBefore) + 1 - $context" />
                     <tr>
                        <td>
                           <xsl:value-of select="$positionRs" />
                        </td>
                        <td>
                           <xsl:copy-of select="$href" />
                        </td>
                        <td>
                           <xsl:text>[...] </xsl:text>
                           <xsl:value-of select="replace(substring($stringBefore, $nbCharBefore, $context - string-length($root/*:rsId[$positionRs])), ' ([.,?:])', '$1')" />
                        </td>
                        <!-- get token -->
                        <td>
                           <xsl:value-of select="$root/*:rsId[$positionRs]" />
                        </td>
                        <!-- get text after // for example 100 chars -->
                        <td>
                           <xsl:value-of select="replace(substring($stringAfter, 1, 200), ' ([.,?:])', '$1')" />
                           <xsl:text> [...]</xsl:text>
                        </td>
                     </tr>
                  </xsl:for-each>
               </table>
            </div>
         </body>
      </html>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Popup Window Template                                                  -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="popup">
      <xsl:variable name="notes" select="document(concat($index.path, 'index.xml'))//*:bibl" />
      <xsl:variable name="mainDocPath">
         <xsl:value-of select="$xtfURL" />
         <xsl:value-of>data/tei</xsl:value-of>
         <xsl:value-of select=" substring-before(substring-after($http.referer, 'docId=tei'), '&amp;')" />
      </xsl:variable>
      <xsl:variable name="mainDocViewPath">
         <xsl:value-of select="$xtfURL" />
         <xsl:value-of>view?docId=tei</xsl:value-of>
         <xsl:value-of select=" substring-before(substring-after($http.referer, 'docId=tei'), '&amp;')" />
      </xsl:variable>
      <xsl:variable name="mainDoc" select="document($mainDocPath)" />
      <html lang="en" xml:lang="en">
         <head>
            <title>
               <xsl:choose>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'implicit')">
                     <xsl:text>Implicit citation</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'paraphrase')">
                     <xsl:text>Paraphrase</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'explicit')">
                     <xsl:text>Explicit Citation</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('note-id', $chunk.id)/self::*:person)">
                     <xsl:text>Person</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('note-id', $chunk.id)/self::*:personGrp)">
                     <xsl:text>Personal Group</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('note-id', $chunk.id))/self::*:item">
                     <xsl:text>Thesaurus</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('bibl', $chunk.id)) or (key('biblScope', $chunk.id))">
                     <xsl:text>Work</xsl:text>
                  </xsl:when>
                  <xsl:when test="(key('note-id', $chunk.id))/self::*:place">
                     <xsl:text>Place</xsl:text>
                  </xsl:when>
               </xsl:choose>
            </title>
            <link href="{$css.path}{$content.css}" rel="stylesheet" type="text/css" />
            <link href="icons/default/favicon.ico" rel="shortcut icon" />
         </head>
         <body>
            <div class="content">
               <xsl:choose>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'implicit')">
                     <xsl:for-each select="$notes[1]">
                        <xsl:apply-templates select="key('biblScope', $chunk.id)" />
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'paraphrase')">
                     <xsl:for-each select="$notes[1]">
                        <xsl:apply-templates select="key('biblScope', $chunk.id)" />
                     </xsl:for-each>
                  </xsl:when>
                  <xsl:when test="(key('quotes', $chunk.id)/@type = 'explicit')">
                     <xsl:for-each select="$notes[1]">
                        <xsl:apply-templates select="key('biblScope', $chunk.id)" />
                     </xsl:for-each>
                  </xsl:when>
                  <!-- thesaurus -->
                  <xsl:when test="(key('note-id', $chunk.id))/self::*:item">
                     <xsl:apply-templates select="key('note-id', $chunk.id)" />
                     <table border="1">
                        <xsl:variable name="root">
                           <xsl:apply-templates mode="text-only" select="$mainDoc" />
                        </xsl:variable>
                        <xsl:for-each select="$mainDoc//*:rs[@ref = concat('#', $chunk.id)]">
                           <xsl:variable name="positionRs" select="position()" />
                           <xsl:variable name="target" select="@target" />
                           <xsl:variable name="anchor" select="preceding::*:pb[1]/@xml:id" />
                           <xsl:variable name="refchunk" select="ancestor::*:div1/@xml:id" />
                           <xsl:variable name="href">
                              <a style="color:brown; text-decoration:none" target="content">
                                 <xsl:attribute name="href">
                                    <xsl:value-of select="$mainDocViewPath" />&#038;doc.view=content&#038;chunk.id=<xsl:value-of select="$refchunk" />&#038;toc.depth=<xsl:value-of select="$toc.depth" />&#038;brand=<xsl:value-of select="$brand" />&amp;#<xsl:value-of select="$anchor" /></xsl:attribute>
                                 <xsl:value-of select="preceding::*:pb[1]/@n" />
                              </a>
                           </xsl:variable>
                           <!-- context (in chars) to display -->
                           <xsl:variable name="context" select="200" />
                           <!-- string before node -->
                           <xsl:variable name="stringBefore">
                              <xsl:value-of select="$root/node()[not(preceding::*:rsId[@xml:id = $positionRs])]" />
                           </xsl:variable>
                           <!-- string after node -->
                           <xsl:variable name="stringAfter">
                              <xsl:value-of select="$root/node()[preceding::*:rsId[@xml:id = $positionRs]]" />
                           </xsl:variable>
                           <xsl:variable name="nbCharBefore" select="string-length($stringBefore) + 1 - $context" />
                           <tr>
                              <td>
                                 <xsl:value-of select="$positionRs" />
                              </td>
                              <td>
                                 <xsl:copy-of select="$href" />
                              </td>
                              <td>
                                 <xsl:text>[...] </xsl:text>
                                 <xsl:value-of select="replace(substring($stringBefore, $nbCharBefore, $context - string-length($root/*:rsId[$positionRs])), ' ([.,?:])', '$1')" />
                              </td>
                              <!-- get token -->
                              <td>
                                 <xsl:value-of select="$root/*:rsId[$positionRs]" />
                              </td>
                              <!-- get text after // for example 100 chars -->
                              <td>
                                 <xsl:value-of select="replace(substring($stringAfter, 1, 200), ' ([.,?:])', '$1')" />
                                 <xsl:text> [...]</xsl:text>
                              </td>
                           </tr>
                        </xsl:for-each>
                     </table>
                  </xsl:when>
                  <xsl:when test="(key('note-id', $chunk.id))">
                     <xsl:apply-templates select="key('note-id', $chunk.id)" />
                  </xsl:when>
                  <xsl:when test="(key('bibl', $chunk.id))">
                     <xsl:apply-templates select="(key('bibl', $chunk.id))" />
                  </xsl:when>
                  <xsl:when test="(key('biblScope', $chunk.id))">
                     <xsl:apply-templates select="(key('biblScope', $chunk.id))" />
                  </xsl:when>
                  <xsl:when test="$fig.ent != '0'">
                     <img alt="full-size image" src="{$fig.ent}" />
                  </xsl:when>
               </xsl:choose>
               <p>
                  <a>
                     <xsl:attribute name="href">javascript://</xsl:attribute>
                     <xsl:attribute name="onclick">
                        <xsl:text>javascript:window.close('popup')</xsl:text>
                     </xsl:attribute>
                     <!-- <span class="down1">Close this Window</span> -->
                  </a>
               </p>
            </div>
         </body>
      </html>
   </xsl:template>
   <xsl:template match="*" mode="text-only">
      <xsl:apply-templates mode="text-only" select="node()" />
   </xsl:template>
   <xsl:template match="*:rs" mode="text-only">
      <xsl:variable name="rsAttribute" select="concat('#', $chunk.id)" />
      <xsl:choose>
         <xsl:when test="@ref = $rsAttribute">
            <xsl:variable name="xmlID">
               <xsl:number count="*:rs[@ref = $rsAttribute]" from="*:front" level="any" />
            </xsl:variable>
            <rsId xml:id="{$xmlID}">
               <xsl:apply-templates mode="text-only" />
            </rsId>
         </xsl:when>
         <xsl:otherwise>
            <xsl:apply-templates mode="text-only" />
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="*:figure" mode="index"> [figure] </xsl:template>
   <xsl:template match="@* | node()" mode="indexII">
      <xsl:param name="hrefParam" />
      <xsl:copy>
         <xsl:copy-of select="$hrefParam" />
         <xsl:apply-templates />
      </xsl:copy>
   </xsl:template>
   <xsl:template match="*:pb" mode="index"> [<xsl:value-of select="@n" />] </xsl:template>
   <xsl:template match="*:note[@type = 'marginalia']" mode="index" />
   <!-- ====================================================================== -->
   <!-- Navigation Bar Template                                                -->
   <!-- ====================================================================== -->
   <xsl:template exclude-result-prefixes="#all" name="navbar">
      <xsl:variable name="prev">
         <xsl:choose>
            <!-- preceding div sibling -->
            <xsl:when test="key('div-id', $chunk.id)/preceding-sibling::*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $chunk.id)/preceding-sibling::*[*:head][@*:id][1]/@*:id" />
            </xsl:when>
            <!-- last div node in preceding div sibling of parent -->
            <xsl:when test="key('div-id', $chunk.id)/parent::*/preceding-sibling::*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $chunk.id)/parent::*/preceding-sibling::*[*:head][@*:id][1]/@*:id" />
            </xsl:when>
            <!-- last div node in any preceding structure-->
            <xsl:when test="key('div-id', $chunk.id)/ancestor::*/preceding-sibling::*/*[*:head][@*:id]">
               <xsl:value-of select="(key('div-id', $chunk.id)/ancestor::*/preceding-sibling::*[1]/*[*:head][@*:id][position() = last()]/@*:id)[last()]" />
            </xsl:when>
            <!-- top of tree -->
            <xsl:otherwise>
               <xsl:value-of select="'0'" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="prev_toc">
         <xsl:choose>
            <xsl:when test="key('div-id', $prev)/*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $prev)/@*:id" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="key('div-id', $prev)/parent::*[*:head][@*:id]/@*:id" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="next">
         <xsl:choose>
            <!-- following div sibling -->
            <xsl:when test="key('div-id', $chunk.id)/following-sibling::*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $chunk.id)/following-sibling::*[*:head][@*:id][1]/@*:id" />
            </xsl:when>
            <!-- first div node in following div sibling of parent -->
            <xsl:when test="key('div-id', $chunk.id)/parent::*/following-sibling::*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $chunk.id)/parent::*/following-sibling::*[*:head][@*:id][1]/@*:id" />
            </xsl:when>
            <!-- first div node in any following structure -->
            <xsl:when test="key('div-id', $chunk.id)/ancestor::*/following-sibling::*/*[*:head][@*:id]">
               <xsl:value-of select="(key('div-id', $chunk.id)/ancestor::*/following-sibling::*[1]/*[*:head][@*:id][1]/@*:id)[1]" />
            </xsl:when>
            <!-- no previous $chunk.id (i.e. titlePage) -->
            <xsl:when test="$chunk.id = '0'">
               <xsl:value-of select="/*/*:text/*[*[*:head][@*:id]][1]/*[*:head][@*:id][1]/@*:id" />
            </xsl:when>
            <!-- bottom of tree -->
            <xsl:otherwise>
               <xsl:value-of select="'0'" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <xsl:variable name="next_toc">
         <xsl:choose>
            <xsl:when test="key('div-id', $next)/*[*:head][@*:id]">
               <xsl:value-of select="key('div-id', $next)/@*:id" />
            </xsl:when>
            <xsl:otherwise>
               <xsl:value-of select="key('div-id', $next)/parent::*[*:head][@*:id]/@*:id" />
            </xsl:otherwise>
         </xsl:choose>
      </xsl:variable>
      <tr>
         <td align="left" width="25%">
            <!-- BEGIN PREVIOUS SELECTION -->
            <a target="_top">
               <xsl:choose>
                  <xsl:when test="$prev != '0'">
                     <xsl:attribute name="href">
                        <xsl:value-of select="$doc.path" />
                        <xsl:text>&#038;chunk.id=</xsl:text>
                        <xsl:value-of select="$prev" />
                        <xsl:text>&#038;toc.id=</xsl:text>
                        <xsl:value-of select="$prev_toc" />
                        <xsl:text>&#038;brand=</xsl:text>
                        <xsl:value-of select="$brand" />
                        <xsl:value-of select="$search" />
                     </xsl:attribute>
                     <img alt="previous" border="0" height="15" src="{$icon.path}b_prev.gif" width="15" />
                  </xsl:when>
                  <xsl:otherwise>
                     <img alt="no previous" border="0" height="15" src="{$icon.path}d_prev.gif" width="15" />
                  </xsl:otherwise>
               </xsl:choose>
            </a>
            <!-- END PREVIOUS SELECTION -->
         </td>
         <td align="center" width="50%">
            <span class="chapter-text">
               <xsl:value-of select="key('div-id', $chunk.id)/ancestor-or-self::*[matches(@*:type, 'fmsec|chapter|bmsec')][1]/*:head[1]" />
            </span>
         </td>
         <td align="right" width="25%">
            <!-- BEGIN NEXT SELECTION -->
            <a target="_top">
               <xsl:choose>
                  <xsl:when test="$next != '0'">
                     <xsl:attribute name="href">
                        <xsl:value-of select="$doc.path" />
                        <xsl:text>&#038;chunk.id=</xsl:text>
                        <xsl:value-of select="$next" />
                        <xsl:text>&#038;toc.id=</xsl:text>
                        <xsl:value-of select="$next_toc" />
                        <xsl:text>&#038;brand=</xsl:text>
                        <xsl:value-of select="$brand" />
                        <xsl:value-of select="$search" />
                     </xsl:attribute>
                     <img alt="next" border="0" height="15" src="{$icon.path}b_next.gif" width="15" />
                  </xsl:when>
                  <xsl:otherwise>
                     <img alt="no next" border="0" height="15" src="{$icon.path}d_next.gif" width="15" />
                  </xsl:otherwise>
               </xsl:choose>
            </a>
            <!-- END NEXT SELECTION -->
         </td>
      </tr>
   </xsl:template>
   <!-- ====================================================================== -->
   <!-- Edit Template                                                  -->
   <!-- ====================================================================== -->
   <!-- <xsl:apply-templates select="/*/*:text/*:back" mode="index"/>  -->
   <xsl:template exclude-result-prefixes="#all" name="edit">
      <html lang="en" xml:lang="en">
         <body>
            <link href="{$css.path}toc.css" rel="stylesheet" type="text/css" />
            <div class="toc">
               <xsl:call-template name="status" />
            </div>
            <div class="toc">
               <xsl:call-template name="indices" />
            </div>
            <div class="toc">
               <xsl:call-template name="data" />
            </div>
         </body>
      </html>
   </xsl:template>
</xsl:stylesheet>
