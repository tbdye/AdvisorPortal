<!--- Footer Model --->
<!--- Thomas Dye, August 2016 --->

<cfset path=ListToArray(GetCurrentTemplatePath(), "\") />
<cfif ArrayLen(path) LTE 1>
	<cfset path="/">
<cfelse>
	<cfset folderName=path[DecrementValue(ArrayLen(path))] />
	<cfset path="/#folderName#/">
</cfif>

	</div>
	<!-- //CONTENT -->
</main>
	
	<div id=footer-wrap>
    	<!-- FOOTER -->
    	<footer id=footer role=contentinfo>
	        <div id=bookmark-top><a href="#top" title="Back to Top" aria-label="Back to Top">&uarr;</a>
	        </div>
			<div class="footerblock block1">
				<div class="vcard" id="footer-contact">
					<address style="font-style:normal;"><a class="fn org url" style="font-weight:bold;font-size:1.1em;" href="http://www.everettcc.edu" rel="publisher">
						<span class="organization-name">Everett Community College</span></a><br>
					<span class="adr"><span class="street-address">2000 Tower Street</span><br>
					<span class="locality">Everett</span>, <span class="region">WA</span> <span class="postal-code">98201</span> <span class="country-name" style="display:none;">USA</span></span>
					</address>
					<p><span class="tel">425-388-9100</span> - 
						<a title="Click for the Center for Disability Services office TTY phone" class="noPrint" href="https://www.everettcc.edu/tty">Need TTY?</a></p>
				</div>		
				<p id="footer-motto">Stay Close... Go Far.</p>	
			</div>

			<div class="footerblock block2">	
				<p class="footer-header"><a href="https://www.everettcc.edu/FAQ"><img id="footer-question" style="width:136px;height:35px;border:0;" alt="Have a Question" src="<cfoutput>#path#</cfoutput>assets/HaveAQuestion.png"></a></p>
				<!--<p class="footer-header">Resources</p>-->
				<ul id="footer-resources" role="list">
					<li><a title="EvCC Emergency Information and Notification Sign-Up" href="https://www.everettcc.edu/emergency/">Emergency Information</a></li>  
					<li><a href="https://www.everettcc.edu/calendar/">Campus Calendar</a></li>
					<li><a href="https://intranet.everettcc.edu">Intranet</a></li>
					<li><a title="Campus IT Help Desk Support" href="https://www.everettcc.edu/helpdesk">IT Help Desk</a></li>  
					<li><a title="Career Opportunities" href="https://www.everettcc.edu/jobs">Jobs</a></li>  
					<li><a title="Campus Directions and Interactive Map" href="https://www.everettcc.edu/maps">Maps &amp; Directions</a></li>  
					<li><a title="Room Rentals and Conference Services through Everett Community College" href="https://www.everettcc.edu/roomrentals">Room Rentals</a></li>  
					<li><a href="http://lawfilesext.leg.wa.gov/law/wsr/agency/EverettCommunityCollege.htm" target="_blank">Rule Making</a></li>
					<li><a title="Campus Safety, Security and Emergency Management" href="https://www.everettcc.edu/security">Security</a></li>
                    <li><a title="Higher Education Act Gainful Employment" href="https://www.everettcc.edu/administration/institutional-effectiveness/institutional-research/gainful-employment/">Gainful Employment</a></li>
				</ul>					
			</div>
			
			<div class="footerblock block3">
	            <p class="footer-header">Connect With EvCC</p>
	            <ul id="footer-social" role="list">
	                   	<li><a href="https://plus.google.com/+EverettccEdu" rel="publisher"><img title="Find Everett Community College on Google+" class="icon-lg" alt="Google+" src="<cfoutput>#path#</cfoutput>assets/google-plus.png"></a></li>
	                   	<li><a href="http://www.facebook.com/EverettCC"><img title="Everett Community College on Facebook" class="icon-lg" alt="Facebook" src="<cfoutput>#path#</cfoutput>assets/facebook.png"></a></li>
	                   	<li><a href="http://twitter.com/EverettCC"><img title="Everett Community College on Twitter" class="icon-lg" alt="Twitter" src="<cfoutput>#path#</cfoutput>assets/twitter.png"></a></li>
	                   	<li><a href="http://www.youtube.com/EverettCommCollege"><img title="Everett Community College on YouTube" class="icon-lg" alt="YouTube" src="<cfoutput>#path#</cfoutput>assets/youtube.png"></a></li>
	                   	<li><a href="https://instagram.com/everettcommcollege/"><img title="Everett Community College on LinkedIn" class="icon-lg" alt="LinkedIn" src="<cfoutput>#path#</cfoutput>assets/instagram.png"></a></li>
	                   	<li><a href="http://www.linkedin.com/company/everett-community-college"><img title="Everett Community College on LinkedIn" class="icon-lg" alt="LinkedIn" src="<cfoutput>#path#</cfoutput>assets/linkedin.png"></a></li>
	            </ul>
            </div>
	        <div id=footer-final>
	            <a href="https://www.everettcc.edu/copyright" title="Copyright Policy for Everett Community College">&copy; Everett Community College</a>
	            | <a href="https://www.everettcc.edu/privacy" title="Privacy Notice">Privacy Notice</a>
	            | <a href="https://www.everettcc.edu/files/administration/policies/evcc3090-title-ix-policy.pdf" title="Anti-Discrimination Policy">Anti-Discrimination Policy</a> (PDF) | <a href="https://www.everettcc.edu/rss/">RSS Feeds</a>
	        </div>

	    </footer>
    	<!-- //FOOTER -->
    </div>

</body>
</html>