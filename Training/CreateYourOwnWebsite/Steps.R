https://bookdown.org/yihui/blogdown/
https://alison.rbind.io/slides/blogdown-workshop-slides.html#1

# 1. Create a repository in Github
# 2. Clone the repository 
# 3. Start Rstudio
# 3a. Verify you have Blogdown installed
# 4. Create a new project in the existing folder
# 5. Tools -> Project Options -> Build Tools -> Website -> deselect all
# 6. We will work with Academic theme https://themes.gohugo.io/

blogdown::install_hugo()

https://gohugo.io/getting-started/configuration/
https://www.webpagefx.com/tools/emoji-cheat-sheet/


blogdown::new_site()

Different theme
blogdown::new_site(theme = "gcushen/hugo-academic", 
                   theme_example = TRUE)

https://sourcethemes.com/academic/docs/

Change your mind
blogdown::install_theme("gcushen/hugo-academic", 
                        theme_example = TRUE, 
                        update_config = TRUE)

# 7. Go to Content -> Home -> delete hero.md
# 8. Addins -> Servesite
# 9. Change the logo -> place the new logo image in static/img
# 10. Open config file, line 65 has avatar. Change to new logo name
# 11. Highlighting, line 151
  highlight = true
  highlight_languages = ["r", "yaml"]
  highlight_style = "atom-one-light"
  highlight_version = "9.9.0"

#12. Social/Academic Networking, line 227
  https://fontawesome.com/icons?from=io
#13. Change envelope -> space-shuttle
#14. Add a new social account
   [[params.social]]
    icon = "linkedin"
    icon_pack = "fa"
    link = "https://www.linkedin.com/in/davidmeza1/"

   [[params.social]]
    icon = "orcid"
    icon_pack = "ai"
    link = "https://orcid.org/0000-0003-2129-862X"
#15. Go to content/home/about.md, make changes

#16. Add public/ to .gitignore -> Deploy to git hub
#17. Need to know your Hugo version
    blogdown::hugo_version()
#17 Deploy to Netlify
   GOTO -> Deploy settings
    hugo
    public

    GOTO -> Build evnironment variable.names
    HUGO_VERSION 0.40.1

    GOTO -> General -> Site informatin -> Change Site Name

GOTO -> config.toml

baseurl = "https://datanautsacademic.netlify.com/"

#18. Create a post
	commit post
	Netlify updates site


    https://www.netlify.com/docs/continuous-deployment/?_ga=2.97573271.949688071.1526327447-1252881172.1526327447#common-configuration-directives















