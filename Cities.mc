module Cities {

    var data = [
        // [city, long, lat]
        ["Uckermunde", 14.046489 , 53.736513],
        ["Pasewalk", 13.990282 , 53.505112]
    ];

    
    function getCity(name) {
        if (data.hasKey(name)) {
            return data[name];
        }
        return null;
    }


    function allCities() {
        return data;
    }

}