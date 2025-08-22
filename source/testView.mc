import Toybox.Graphics;
import Toybox.WatchUi;
import Toybox.Timer;
using Toybox.Position;
using Toybox.System;

class testView extends WatchUi.View {

    var myTimer;
    var myLocation;
    var counter=0;
    var locationName;

    var Uckermunde = [14.046489,53.736513];
    var Pasewalk = [13.990282,53.505112];

    function initialize() {
        View.initialize();
        myLocation = null;
        Position.enableLocationEvents(Position.LOCATION_CONTINUOUS, method(:onPosition));
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
        myTimer.start(method(:onTick), 5000, true);
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
        //dc.drawText(dc.getWidth()/2,  dc.getHeight()/2, Graphics.FONT_LARGE, counter, Graphics.TEXT_JUSTIFY_CENTER);
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
        counter +=1;
        
        if (myLocation != null) {
            System.println("Current location: " + myLocation[0] + ", " + myLocation[1]);

            var uck_distance = distanceToCurrent(Uckermunde[1], Uckermunde[0], myLocation[0], myLocation[1]);
            var pase_distance = distanceToCurrent(Pasewalk[1], Pasewalk[0], myLocation[0], myLocation[1]);
            
            System.println("uck_distance " + uck_distance);
            System.println("pase_distance " + pase_distance);

            if (uck_distance < pase_distance){
                System.println("Near ucker");
                locationName = "Ueckermünde";
            } else{
                System.println("Near pasewalk");
                locationName = "Pasewalk";
            }
  
  
        } else {
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

    
    function distanceToCurrent(lat1, lon1, lat2, lon2) {
               
        var dLat = lat1 - lat2;
        var dLon = lon1 - lon2;

        var distance = Math.sqrt(dLat*dLat + dLon*dLon);

        return distance;   
    }

}
