
function createMockTop10() as object
    cn = createObject("roSGNode","ContentNode")
    aa = {
        focusable: false,
        id: "tm47834",
        person_id: "nm0000123",
        person_name: "Robert Downey Jr.",
        role: "actor",
        streaming_service: "netflix",
      
    }
    cn.update(aa)
    return cn
end function


function createMockTitles() as object
    titlesAA = createObject("roArray", 10, true)
    aa = {
        title_id: "ts21321",
        title_name: "The Real World",
        type: "SHOW",
        release_year: "2023",
        age_certification: "TV-14",
        rating: "PG-13",
        genre: "[Action, comedy,animation,documentary,drama,history]",
        production_country: "[USA]",
        imdb_score: "6.2",
        streaming_service: "amazon",
    }

    return titlesAA
end function

function createMockCredits() as object
    creditsAA = createObject("roArray", 10, true)
    aa = {
        title_id: "tm47834",
        person_id: "20266",
        person_name: "Fritz Lang",
        role: "Director",
        character_name: "",
        streaming_service: "hbo",
    }

    return creditsAA
end function