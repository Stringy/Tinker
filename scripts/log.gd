extends Node

var enabled: bool = true

func _do_log(tag, msg, frame=get_stack()[2]):
    if not enabled:
        return
    print("[%s]%30s:%-4d %s" % [
        tag,
        frame.source.get_file(),
        frame.line,
        msg
    ])

func debug(msg):
    _do_log("D", msg)
    
func error(msg):
    _do_log("E", msg)

func info(msg):
    _do_log("I", msg)
    
func maybe_error(value):
    if value == OK:
        return
    _do_log("E", "call failed", get_stack()[1])
    
