# hubot-capmetro
A Hubot script to find out when the next CapMetro bus will show up.

## Installation

Install the script : 

    npm install --save hubot-capmetro

Enable it by adding to your `external-scripts.json` file.

    [
      ...
      "hubot-capmetro",
      ...
    ]

## Configuration

There's one required configuration variable to set: `HUBOT_CAPMETRO_BUSES`
This should be a JSON object matching bus numbers with Capital Metro Stop IDs. For example: 

    HUBOT_CAPMETRO_BUSES='{ "803N": 5865, "1N": 1042 }'

That string would set Hubot up to retrieve arrival times for the northbound 803 at stop 5865 and the northbound number 1 from stop 1042.

There's also one optional variable: `HUBOT_CAPMETRO_DEFAULT_DIR`.  If you have
two buses with the same number (the 803 northbound and southbound, for example), 
and you don't specify a direction when asking for the next time, Hubot will use
this value for the direction.


## Interaction

An example interaction, using the buses specified above:

    larcher: hubot next 19
    hubot: Next 19 heading N will arrive in 5 minutes (04:21 PM)

    larcher: hubot, next 19 after that
    hubot: Second 19 heading N will arrive in 26 minutes (04:42 PM)

And here's an example of the default direction setting.  To be able to retrieve times for the 803 going north and south from Guadalupe at UT's West Mall, you might configure Hubot like this:

    export HUBOT_CAPMETRO_BUSES='{ "803N": 5865, "803S": 497 }'
    export HUBOT_CAPMETRO_DEFAULT_DIR='N'

And interact with him like so:

    larcher: hubot next 803
    hubot: Next 803 heading N will arrive in 5 minutes (04:21 PM)

    larcher: hubot next 803s
    hubot: Next 803 heading S will arrive in 3 minutes (04:19 PM)

