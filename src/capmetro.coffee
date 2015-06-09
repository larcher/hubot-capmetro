# description:
#   Get next bus times from CapMetro
#
# dependencies:
#   none
#
# configuration:
#   none
#
# commands:
#   hubot next <bus number> - get the next departure time of that bus
#   hubot next <bus number> after that - get the next-next departure time of that bus
#
# author:
#   larcher


# match up buses with Stop ID's
bus_stops = {
  "803N" :  5865,
  "801N" :  5865,
  "1N"   :  1042,
  "3N"   :  1042,
  "5N"   :  1042,
  "982N" :  1042,
  "983N" :  1042,
  "987N" :  1042,
  "640C" :  1042,
  "19N"  :  1042,
  "803S" :  497,
  "801S" :  497,
  "1S"   :  497,
  "3S"   :  497,
  "5S"   :  497,
  "982S" :  497,
  "983S" :  497,
  "987S" :  497,
  "19S"  :  497,
}

# If you don't specify a direction after the bus number, use this direction
default_dir = 'N'

module.exports = (robot) ->
  robot.respond /next ([0-9]+) ?([nsewc]?)\b(after that)?/i, (msg) ->
    route = msg.match[1]
    dir = msg.match[2]
    nextnext = msg.match[3]
    if nextnext
      bus_index = 1
    else
      bus_index = 0
    if not dir
      # Forty Acres (640) is special, has a circular route, not North or South
      if route == "640"
        dir = "C"
      else
        dir = default_dir

    dir = dir.toUpperCase()
    stop = bus_stops[route+dir]

    url = "http://www.capmetro.org/planner/s_nextbus2.asp?stopid=" + stop + "&route=" + route + "&dir=" + dir + "&opt=2"

    robot.http(url).get() (err,res,body) ->
      if err or res.statusCode != 200
        console.log "Error getting bus info"
        console.log err
        console.log res
        console.log body
        return false
      data = JSON.parse(body)
      if data.status == "OK"
        if data.list.length > 0
          next_bus = data.list[bus_index]
          msg.send (if nextnext then "Second " else "Next ") + route + " heading " + dir + " will arrive in " + next_bus.estMin + " minutes (" + next_bus.est + ")" + (if next_bus.real then "" else " (realtime data not available)")
        else
          msg.send "No times found for " + route + dir + " at stop " + stop
      else
        msg.send data.status

