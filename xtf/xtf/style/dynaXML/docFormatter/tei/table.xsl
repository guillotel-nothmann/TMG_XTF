<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all">

   <!--
      Copyright (c) 2008, Regents of the University of California
      All rights reserved.
      
      Redistribution and use in source and binary forms, with or without 
      modification, are permitted provided that the following conditions are 
      met:
      
      - Redistributions of source code must retain the above copyright notice, 
      this list of conditions and the following disclaimer.
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


   <xsl:template match="*:table">
      
      <xsl:choose>
         <xsl:when test="child::*:pb"> <!-- tableau séparé par <pb> il faut décomposer: <table/><pb/><table/> -->
            <xsl:variable name="tp1">
               <table>
                  <xsl:copy-of select="*:head"/>
                  <xsl:copy-of select="*:row [not(preceding-sibling::*:pb)]"/>
               </table>
            </xsl:variable>
            <xsl:variable name="pb">
               <xsl:copy-of select="*:pb"/>
            </xsl:variable>
            <xsl:variable name="tp2">
               <table>
                  <xsl:copy-of select="*:row [not(following-sibling::*:pb)]"/>
               </table>
            </xsl:variable>
            <xsl:for-each select="$tp1/*:table"> 
                <xsl:call-template name="table_create"/>
            </xsl:for-each>
            <xsl:for-each select="$pb">
               <xsl:apply-templates/>
            </xsl:for-each>
            <xsl:for-each select="$tp2/*:table"> 
                <xsl:call-template name="table_create"/>
            </xsl:for-each>
         </xsl:when>
         <xsl:otherwise> <!-- tableu simple sur une seule page -->
            <xsl:call-template name="table_create"/>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   
   <xsl:template name="table_create">
       <xsl:if test="$anchor.id=@*:id">
               <a name="X"/>
            </xsl:if>
   
            <div align="center" style="margin-top:1.5em; margin-bottom:1.5em">
               <xsl:element name="table">
                  <xsl:copy-of select="@*"/>
                  <xsl:attribute name="BGCOLOR">
                     <xsl:choose>
                        <xsl:when test="@rend='list' or @rend='noline'">white</xsl:when>
                        <xsl:otherwise>grey</xsl:otherwise>
                     </xsl:choose>
                  </xsl:attribute>
                  <xsl:choose>
                     <xsl:when test="@border"/>
                     <xsl:otherwise>
                        <xsl:attribute name="border">0</xsl:attribute>
                     </xsl:otherwise>
                  </xsl:choose>
                  <xsl:apply-templates/>
                  <xsl:if test="normalize-space(.)">
                     <xsl:text>&#160;</xsl:text>
                  </xsl:if>
               </xsl:element>
            </div>
   </xsl:template>



   <!-- TEI table model -->

   <xsl:template match="*:row">


      <xsl:element name="tr">


         <xsl:attribute name="BGCOLOR">white</xsl:attribute>
         <xsl:copy-of select="@*"/>

         <xsl:apply-templates/>

         <xsl:if test="normalize-space(.)">
            <xsl:text>&#160;</xsl:text>
         </xsl:if>
      </xsl:element>

   </xsl:template>

   <xsl:template match="*:cell">
      <xsl:element name="td">
         
            
         
         <xsl:attribute name="valign">
            <xsl:choose>
               <xsl:when test="ancestor::*:table/@rend='list'">top</xsl:when>
               <xsl:otherwise>center</xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:attribute name="align">
            <xsl:choose>
               <xsl:when test="@rend='right'">right</xsl:when>
               <xsl:when test="@rend='center'">center</xsl:when>
               <xsl:otherwise>left</xsl:otherwise>
            </xsl:choose>
         </xsl:attribute>
         <xsl:copy-of select="@*[not(name()='cols' and name()='rows')]"/>
         <xsl:if test="@cols">
            <xsl:attribute name="colspan" select="@cols"/>
         </xsl:if>
         <xsl:if test="@rows">
            <xsl:attribute name="rowspan" select="@rows"/>
         </xsl:if>
        <!-- <xsl:if test="not(string(.)) and not( child::*)">
            <xsl:attribute name="BGCOLOR">grey</xsl:attribute>
         </xsl:if>-->
          
         <xsl:apply-templates/>
         
         <xsl:if test="normalize-space(.)">
            <xsl:text>&#160;</xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <!-- HTML Table Model -->

   <xsl:template match="*:caption[ancestor::*:table]">
      <xsl:element name="caption">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:head [ancestor::*:table and not(ancestor::*:figure)]">
      <span style="text-align:justify; line-height:1.4em; font-size:1.15em"> 
         <xsl:element name="head"> 
            <xsl:apply-templates/>
         </xsl:element>
      </span>

   </xsl:template>

   <xsl:template match="*:tfoot">
      <xsl:element name="tfoot">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:tbody">
      <xsl:element name="tbody">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:colgroup">
      <xsl:element name="colgroup">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:col">
      <xsl:element name="col">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:tr">
      <xsl:element name="tr">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

   <xsl:template match="*:th">
      <xsl:element name="th">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>
   
 

   <xsl:template match="*:td">
      <xsl:element name="td">
         <xsl:copy-of select="@*"/>
         <xsl:apply-templates/>
         <xsl:if test="normalize-space(.)">
            <xsl:text> </xsl:text>
         </xsl:if>
      </xsl:element>
   </xsl:template>

</xsl:stylesheet>
