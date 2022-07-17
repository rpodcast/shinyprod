
# shinyprod

<!-- badges: start -->
<!-- badges: end -->

`{shinyprod}` is a companion package for the **Building Production-Quality Shiny Applications** workshop at rstudio::conf(2022). More information on the workshop can be found at [shinyprod.com](https://shinyprod.com). The goal of the package is to let workshop attendees easily deploy Shiny applications built during the workshop exercises and other coding sessions using one function called `shinyprod_deploy()`. This function can also be executed by selecting the **Deploy Shiny App** add-in from the RStudio Addins menu.

## Important Note

Please note that this package is very specific to using infrastructure such as RStudio Cloud and RStudio Connect that was specifically created for the workshop.

## Installation

For workshop attendees, this package will be automatically included in the project environment used within RStudio Cloud. If you are using your own installation of R on a local machine, you can install the development version of `{shinyprod}` from [GitHub](https://github.com/) with:

``` r
# install.packages("remotes")
remotes::install_github("rpodcast/shinyprod")
```

## Environment Variables Setup

The package will not be able to deploy applications without the user establishing an account on the workshop RStudio Connect server. After the account is created and an account API key is created (instructions will be provided during the workshop), you will need to create a file called `.Renviron` within the workshop project's root directory with variables called `CONNECT_SERVER` and `CONNECT_API_KEY`. The file should follow this structure (substitute the provided workshop server and your account API key as appropriate):

```
CONNECT_SERVER="https://workshop-server.com"
CONNECT_API_KEY="abcdefghijklmnopqrstuvwxyz"
```
