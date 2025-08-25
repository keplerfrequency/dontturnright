import Cities;
import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
using Toybox.Position;
using Toybox.System;

class testView extends WatchUi.View {

    var myTimer;
    var myLocation;
    var locationName;
    var locationPopulation;
    var locationPopulationWritten;
    var currentAFD;

    // Variables to be written on display
    var locationText;
    var populationText;
    var afdText;
   
    //List of all the gemeinde
    var gemeinde;

    // Used to cycle through
    var closestGemeinde;
    var nextGemeinde;

    var distanceClosest;
    var distanceNext;

    function initialize() {
        View.initialize();
        myLocation = null;
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
        gemeinde = Cities.allCities();
    }

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
        myTimer = new Timer.Timer();
        myTimer.start(method(:onTick), 6000, true);
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        // Call the parent onUpdate function to redraw the layout
        dc.clear();
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        if (myLocation != null) {

            var populationQuantifier = "K";

            //Check if above 1M population
            if(locationPopulation != null){
                if(locationPopulation > 1000){ 
                    populationQuantifier = "M";
                    locationPopulationWritten = locationPopulation.toString();
                    locationPopulationWritten = locationPopulationWritten.substring(0,1) + "." + locationPopulationWritten.substring(1, locationPopulationWritten.length());
                }else{
                    locationPopulationWritten = locationPopulation;
                }
            }

             if (locationName != null){
                locationText = "You are in/near: " + locationName;
             }else{
                locationText = "Checking location in database...";
             }
            
            if (locationPopulationWritten != null){
                populationText =  "\nPopulation: " + locationPopulationWritten + populationQuantifier; 
            }else{
                populationText = "\nHow many people live here???";
            }
            
            if (currentAFD == null){
                afdText = "\nUnknown AFD";
            }else{
                afdText =  "\nCurrent AFD: " + currentAFD + " %\n";
                
                if(currentAFD < 10){
                    afdText = afdText + "\nNot bad, don't let your guard down";
                }
                if(currentAFD >= 10 && currentAFD <= 20){
                    afdText = afdText + "\nBelow the national average \nFor now...";
                }
                if(currentAFD >= 20 && currentAFD <= 30){
                    afdText = afdText + "\nAchtung! Be careful with the Nazi's";
                }
                if(currentAFD >= 30 && currentAFD < 40){
                    afdText = afdText + "\nThis is not looking good.\n Are you in the former GDR?";
                }
                if(currentAFD >= 40){
                    afdText = afdText + "\nAlmost 1 in 2 \nhere voted AfD. \nLet that sink in.";
                }
                
            }
            
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 30, Graphics.FONT_SMALL, locationText + populationText + afdText, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 - 30, Graphics.FONT_SMALL, "Getting GPS...", Graphics.TEXT_JUSTIFY_CENTER);
        }
    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
        if (myTimer != null) {
            myTimer.stop();
            myTimer = null;
        }
    }

    function onTick() as Void{
        
        if (myLocation != null) {
            closestGemeinde = null;
            var minDistance = 9999999;

            // Go through all the gemeinde and check which one is the closest
            for (var i=0; i< gemeinde.size(); i+=1){

                nextGemeinde = gemeinde[i];

                // Attention: Lat and Lon are switched - check indexes well
                var distance = distanceToCurrent(nextGemeinde[2], nextGemeinde[1], myLocation[0], myLocation[1]);
                
                if(distance < minDistance){
                    minDistance = distance;
                    closestGemeinde = nextGemeinde;
                }
            }
            
            if (closestGemeinde != null) {
                System.println("Closest is " + closestGemeinde[0] + " (" + minDistance + " m)");
                locationName = closestGemeinde[0];
                locationPopulation = closestGemeinde[3];
                currentAFD = closestGemeinde[4];
            }
  
        }else {
            System.println("Location not yet available");
        }
  
        //System.println(myLocation);
        requestUpdate();
    // Update widget content here
    }
    

    function onPosition(info as Position.Info) as Void{
        if (info.position != null) {
            myLocation = info.position.toDegrees();
        } else {
            System.println("GPS position is null");
        }
        requestUpdate(); // Update display when new location is received
    }

    // Very coarse function to determine which gemeente is closer
    function distanceToCurrent(lat1, lon1, lat2, lon2) {
               
        var dLat = lat1 - lat2;
        var dLon = lon1 - lon2;

        var distance = Math.sqrt(dLat*dLat + dLon*dLon);

        return distance;   
    }
 
}
