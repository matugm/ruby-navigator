fs   = require 'fs-plus'
path = require 'path'

# jQuery
{$} = require('atom-space-pen-views')

# Open file on click
$(document).ready ->
  $('.method').on 'click', (e) ->
    method  = $(this)
    promise = atom.workspace.open(method.data("name"), { initialLine: method.data("line") })
    #console.log (method.data("name") + " " + method.data("line"))

module.exports =
class RubyNavigatorView

  constructor: (serializedState) ->
    # Create root element
    @navigator = document.createElement('div')
    @navigator.classList.add('ruby-navigator')

  load_data: ->
    projectPath = atom.project.getPaths()[0]
    file = path.join(projectPath, 'class-index.json')

    return if (!fs.existsSync(file))

    contents = fs.readFileSync(file)
    json     = JSON.parse(contents)

    for own file_name of json
      for own class_name of json[file_name]
        (this.add_class(class_name))
        (this.add_method(method, file_name) for method in json[file_name][class_name])

  add_method: (method, file_name) ->
    message = document.createElement('a')
    message.textContent = method["name"]
    message.setAttribute('data-name', file_name) # needs to be file name instead of method name
    message.setAttribute('data-line', method["line"])
    message.classList.add('method')
    @navigator.appendChild(message)

  add_class: (name) ->
    message = document.createElement('div')
    message.textContent = name
    message.classList.add('ruby-class')
    @navigator.appendChild(message)

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @navigator.remove()

  getElement: ->
    @navigator
