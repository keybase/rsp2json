

{Engine} = require '../lib/engine'
argv = require('optimist')
         .demand(1)
         .alias('a', 'assign-to')
         .describe('a', 'Output JS and assign to the given variable')
         .argv

exports.main = () ->
  file = argv._[0]
  engine = new Engine file
  await engine.run defer err, records
  if err?
    console.error err
    sys.exit -1
  output = JSON.stringify records, null, 4
  if argv.a?
    output = argv.a + " = " + output + ";"
  console.log output


