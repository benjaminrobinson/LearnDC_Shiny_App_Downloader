# myfile.R
options(stringsAsFactors=FALSE)
if(!require(jsonlite)){
  install.packages("jsonlite")
  library(jsonlite)
}

leadgr <- function(x, y){
  if(!is.na(x)){
    while(nchar(x)<y){
      x <- paste("0",x,sep="")
    }
  }
  return(x)
}

`%notin%` <- function(x,y) !(x %in% y)


#* @get /school
GetSchool <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('school') to get the correct names of LearnDC's School Exhibits.")
  }
  else {
    school <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=school&sha=promoted"))
    school$org_code <- sapply(school$org_code,leadgr,4)
    
    school_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/schools?sha=promoted")[2:3],org_code %in% school$org_code)
    school <- merge(school,school_overview,by=c('org_code'),all.x=TRUE)
    school <- school[c(1:2,ncol(school),3:(ncol(school)-1))]

    if(exhibit %in% c('graduation','dccas','attendance','special_ed','enrollment','mgp_scores','suspensions','enrollment_equity','amo_targets','accountability')){
      school$subgroup <- tolower(school$subgroup)
        subgroup_map <- subgroup_map <- c("bl7"="african american",
                            "wh7"="white",
                            "hi7"="hispanic",
                            "as7"="asian",
                            "mu7"="multiracial",
                            "pi7"="pacific islander",
                            "am7"="american indian",
                            "direct cert"="tanf/snap eligible",
                            "economy"="economically disadvantaged",
                            "lep"="english learner",
                            "sped"="special education",
                            "sped level 1"="special education level 1",
                            "sped level 2"="special education level 2",
                            "sped level 3"="special education level 3",
                            "sped level 4"="special education level 4",
                            "all sped students"="special education",
                            "alt test takers"="alternative testing",
                            "with accommodations"="testing accommodations",
                            "all"="all",
                            "female"="female",
                            "male"="male",
                            "asian"="asian",
                            "economically disadvantaged"="economically disadvantaged",
                            "african american"="african american",
                            "english learner"="english learner",
                            "hispanic"="hispanic",
                            "multiracial"="multiracial",
                            "pacific islander"="pacific islander",
                            "special education"="special education",
                            "white"="white")
        
        school$subgroup <- subgroup_map[school$subgroup]
        }

    if(exhibit %in% c('enrollment','enrollment_equity')){
        school$year <- paste0(school$year,"-",school$year+1)
        } else {
        school$year <- paste0(school$year-1,"-",school$year)
    }
  }
  school$population <- NULL
  return(school)
}


#* @get /lea
GetLEA <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('lea') to get the correct names of LearnDC's LEA Exhibits.")
  }
  else {
 lea <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&sha=promoted"))
 lea$org_code <- sapply(lea$org_code,leadgr,4)
 lea <- subset(lea,org_code %notin% c('0000','0001','6000'))
  
 lea_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% lea$org_code)
 lea <- merge(lea,lea_overview,by=c('org_code'),all.x=TRUE)
 lea <- lea[c(1:2,ncol(lea),3:(ncol(lea)-1))]

if(exhibit %in% c('graduation','dccas','special_ed','enrollment')){
        lea$subgroup <- tolower(lea$subgroup)
        subgroup_map <- c("bl7"="african american",
                            "wh7"="white",
                            "hi7"="hispanic",
                            "as7"="asian",
                            "mu7"="multiracial",
                            "pi7"="pacific islander",
                            "am7"="american indian",
                            "direct cert"="tanf/snap eligible",
                            "economy"="economically disadvantaged",
                            "lep"="english learner",
                            "sped"="special education",
                            "sped level 1"="special education level 1",
                            "sped level 2"="special education level 2",
                            "sped level 3"="special education level 3",
                            "sped level 4"="special education level 4",
                            "all sped students"="special education",
                            "alt test takers"="alternative testing",
                            "with accommodations"="testing accommodations",
                            "all"="all",
                            "female"="female",
                            "male"="male",
                            "asian"="asian",
                            "economically disadvantaged"="economically disadvantaged",
                            "african american"="african american",
                            "english learner"="english learner",
                            "hispanic"="hispanic",
                            "multiracial"="multiracial",
                            "pacific islander"="pacific islander",
                            "special education"="special education",
                            "white"="white")

        lea$subgroup <- subgroup_map[lea$subgroup]
        }

    if(exhibit %in% c('enrollment')){
        lea$year <- paste0(lea$year,"-",lea$year+1)
    } else {
        lea$year <- paste0(lea$year-1,"-",lea$year)
    }
  }
  lea$population <- NULL
  return(lea)
}

#* @get /sector
GetSector <- function(exhibit){
  exhibit <- tolower(exhibit)
  if(exhibit %notin% c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment")){
    stop("The requested exhibit does not exist.\r
Please check the spelling of your exhibit using GetExhibits('sector') to get the correct names of LearnDC's Sector Exhibits.")
  } else {
 sector <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=lea&s[][org_code]=0001&s[][org_code]=0000&&s[][org_code]=6000&sha=promoted"))
 sector$org_code <- sapply(sector$org_code,leadgr,4)
  
 sector_overview <- subset(jsonlite::fromJSON("https://learndc-api.herokuapp.com//api/leas?sha=promoted")[2:3],org_code %in% sector$org_code)
 sector <- merge(sector,sector_overview,by=c('org_code'),all.x=TRUE)
 sector$org_type <- "sector"
 sector <- sector[c(1:2,ncol(sector),3:(ncol(sector)-1))]

 if(exhibit %in% c('graduation','dccas','special_ed','enrollment')){
    sector$subgroup <- tolower(sector$subgroup)
    subgroup_map <- c("bl7"="african american",
                            "wh7"="white",
                            "hi7"="hispanic",
                            "as7"="asian",
                            "mu7"="multiracial",
                            "pi7"="pacific islander",
                            "am7"="american indian",
                            "direct cert"="tanf/snap eligible",
                            "economy"="economically disadvantaged",
                            "lep"="english learner",
                            "sped"="special education",
                            "sped level 1"="special education level 1",
                            "sped level 2"="special education level 2",
                            "sped level 3"="special education level 3",
                            "sped level 4"="special education level 4",
                            "all sped students"="special education",
                            "alt test takers"="alternative testing",
                            "with accommodations"="testing accommodations",
                            "all"="all",
                            "female"="female",
                            "male"="male",
                            "asian"="asian",
                            "economically disadvantaged"="economically disadvantaged",
                            "african american"="african american",
                            "english learner"="english learner",
                            "hispanic"="hispanic",
                            "multiracial"="multiracial",
                            "pacific islander"="pacific islander",
                            "special education"="special education",
                            "white"="white")
      
      sector$subgroup <- subgroup_map[sector$subgroup]
        }

    if(exhibit %in% c('enrollment')){
        sector$year <- paste0(sector$year,"-",sector$year+1)
    } else {
        sector$year <- paste0(sector$year-1,"-",sector$year)
    }
  }
  sector$population <- NULL
  return(sector)
}

#* @get /state
GetState <- function(exhibit){
    exhibit <- tolower(exhibit)
	if(exhibit %notin% c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","expulsions","mid_year_entry_and_withdrawal")){
    stop("The requested exhibit does not exist.\r
    Please check the spelling of your exhibit using GetExhibits('state') to get the correct names of LearnDC's State Exhibits.")
	}
	else {
    state <- read.csv(paste0("https://learndc-api.herokuapp.com//api/exhibit/",exhibit,".csv?s[][org_type]=state&s[][org_type]=DC&sha=promoted"))
    state$org_name <- "DC"

    if(exhibit %in% c('graduation','dccas','attendance','special_ed','enrollment','mgp_scores','naep_results','suspensions','enrollment_equity','amo_targets','accountability')){
        state$subgroup <- tolower(state$subgroup)
         subgroup_map <- c("bl7"="african american",
                            "wh7"="white",
                            "hi7"="hispanic",
                            "as7"="asian",
                            "mu7"="multiracial",
                            "pi7"="pacific islander",
                            "am7"="american indian",
                            "direct cert"="tanf/snap eligible",
                            "economy"="economically disadvantaged",
                            "lep"="english learner",
                            "sped"="special education",
                            "sped level 1"="special education level 1",
                            "sped level 2"="special education level 2",
                            "sped level 3"="special education level 3",
                            "sped level 4"="special education level 4",
                            "all sped students"="special education",
                            "alt test takers"="alternative testing",
                            "with accommodations"="testing accommodations",
                            "all"="all",
                            "female"="female",
                            "male"="male",
                            "asian"="asian",
                            "economically disadvantaged"="economically disadvantaged",
                            "african american"="african american",
                            "english learner"="english learner",
                            "hispanic"="hispanic",
                            "multiracial"="multiracial",
                            "pacific islander"="pacific islander",
                            "special education"="special education",
                            "white"="white")
        state$subgroup <- subgroup_map[state$subgroup]
        }
        
    if(exhibit %in% c('enrollment','enrollment_equity','ell')){
        state$year <- paste0(state$year,"-",state$year+1)
        }
    else if(exhibit %in% 'naep_results'){
        state$year <- state$year
        }
    else{
        state$year <- paste0(state$year-1,"-",state$year)
        }
        return(state[c(1:2,ncol(state),3:(ncol(state)-1))])
 	}
 }

#* @get /exhibits
 GetExhibits <- function(level){
	level <- tolower(level)
	if(level %notin% c("school","lea","sector","state")){
    stop("The requested level does not exist.\r
Please only use these levels as arguments for this function:  school, lea, sector, and state.")
  } else {
  	exhibits <- list(
	'school' = c("graduation","dccas","attendance","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","accountability_classification","pcsb_pmf","mid_year_entry_and_withdrawal"),
	'lea' = c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment"),
	'sector' = c("graduation","dccas","hqt_classes","staff_degree","mgp_scores","special_ed","enrollment"),
	'state' = c("graduation","dccas","attendance","naep_results","hqt_classes","staff_degree","mgp_scores","ell","special_ed","enrollment","suspensions","expulsions","enrollment_equity","accountability","amo_targets","mid_year_entry_and_withdrawal")
)
	return(print(exhibits[[level]]))
	}
}
