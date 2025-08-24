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

    //var Uckermunde = [14.046489,53.736513];
    //var Pasewalk = [13.990282,53.505112];
   
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
            var locationText = locationName + "\nLat: " + myLocation[0] + "\nLon: " + myLocation[1];
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 30, Graphics.FONT_SMALL, locationText, Graphics.TEXT_JUSTIFY_CENTER);
        } else {
            dc.drawText(dc.getWidth()/2, dc.getHeight()/2 + 30, Graphics.FONT_SMALL, "Getting GPS...", Graphics.TEXT_JUSTIFY_CENTER);
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
            /*System.println("Current location: " + myLocation[0] + ", " + myLocation[1]);

            closestGemeinde = gemeinde[0];
            nextGemeinde = gemeinde[1];

            //System.println(gemeinde);

            distanceClosest = distanceToCurrent(gemeinde[0][2], gemeinde[0][1], myLocation[0], myLocation[1]);
            distanceNext = distanceToCurrent(gemeinde[1][2], gemeinde[1][1], myLocation[0], myLocation[1]);
            
            System.println("uck_distance " + distanceClosest);
            System.println("pase_distance " + distanceNext);

            if (distanceClosest < distanceNext){
                System.println("You are currently in " + closestGemeinde[0]);
                locationName = closestGemeinde[0];
            } else{
                System.println("You are currently in " + nextGemeinde[0]);
                locationName = nextGemeinde[0];
            }*/
  
            closestGemeinde = null;
            var minDistance = 9999999;

            for (var i=0; i< gemeinde.size(); i+=1){

                nextGemeinde = gemeinde[i];

                var distance = distanceToCurrent(nextGemeinde[2], nextGemeinde[1], myLocation[0], myLocation[1]);
                
                if(distance < minDistance){
                    minDistance = distance;
                    closestGemeinde = nextGemeinde;
                }
            }
            
            if (closestGemeinde != null) {
                System.println("Closest is " + closestGemeinde[0] + " (" + minDistance + " m)");
                locationName = closestGemeinde[0];
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
            //System.println("GPS Update - Lat: " + myLocation[0] + ", Lon: " + myLocation[1]);
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
