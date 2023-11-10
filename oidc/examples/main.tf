module "oidc" {
    source = "../"
   
    oidc = {
       example1 = {
        "url_certificate_get" = "https://token.actions.githubusercontent.com/"
        "url_connect_provider" = "https://token.actions.githubusercontent.com/"
        
        additional_thumbprints = ["6938fd4d98bab03faadb97b34396831e3780aea1"]
 
      }

    }

}