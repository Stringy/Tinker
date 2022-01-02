extends Node2D

const num_workers: int = 1

var worker_threads = []
var job_ready: Semaphore
var job_mutex: Mutex
var job_queue: Array

var exit_mutex: Mutex
var should_exit: bool = false

var terrain_mutex: Mutex
var terrain: Dictionary = {}

var plains_biome = preload("res://resources/biomes/plains.tres")

signal terrain_generated(area)

func _ready():
    job_ready = Semaphore.new()
    job_mutex = Mutex.new()
    job_queue = []

    exit_mutex = Mutex.new()
    terrain_mutex = Mutex.new()

    for i in self.num_workers:
        var thread = Thread.new()
        thread.start(self, "_terrain_generation")
        self.worker_threads.append(thread)

#
# Main thread function, for picking up jobs from the job queue
# and generating terrain regions before posting them back to 
# the completed generation list
#
func _terrain_generation():
    while true:
        if self._thread_should_stop():
            break

        var job = self._thread_get_job()
        var region = self._generate_region(job)
        self._post_generated_region(region)

#
# Helper function for checking whether the thread should exit
#
func _thread_should_stop():
    self.exit_mutex.lock()
    var stop = self.should_exit
    self.exit_mutex.unlock()
    return stop

#
# Attempts to get a job from the job queue. Handles waiting for 
# new jobs.
#
func _thread_get_job():
    var err = self.job_ready.wait()
    if err != OK:
        return err
    self.job_mutex.lock()
    var job = self.job_queue.pop_front()
    self.job_mutex.unlock()
    return job

#
# A region represents a generated part of the world. It 
# contains biome information as well as object kind and placement
#
class Region:
    var transform: Rect2
    var biome: Biome
    var tiles: Array = []
    var trees: Array = []
    var grass: Array = []

    func _to_string():
        return "Region(" + str(self.transform) + ")"

#
# This actually does the work of generating a region of the terrain
#
func _generate_region(job: Rect2) -> Region:
    var region = Region.new()
    var biome = plains_biome
    region.transform = job

    for y in job.size.y:
        var row = []
        for x in job.size.x:
            var x_coord = job.position.x + x
            var y_coord = job.position.y + y
            var idx = biome.get_tile_idx(x_coord, y_coord)
            row.push_back(idx)
            
            if biome.should_place_tree(x_coord, y_coord):
                region.trees.push_back(Vector2(x_coord, y_coord))
            elif biome.should_place_grass(x_coord, y_coord):
                region.grass.push_back(Vector2(x_coord, y_coord))
                
        region.tiles.push_back(row)

    return region
    
#
# Sends the generated region to the completed list
#
func _post_generated_region(region: Region) -> void:
    self.terrain_mutex.lock()
    self.terrain[region.transform] = region
    self.terrain_mutex.unlock()
    self.emit_signal("terrain_generated", region.transform)

#
# Pushes the given region to the job queue for generation
#
func queue_generation(region: Rect2):
    self.job_mutex.lock()
    self.job_queue.push_back(region)
    self.job_mutex.unlock()
    Log.maybe_error(self.job_ready.post())

#
# Retrieves a generated terrain region from the cache
# TODO: figure out what to do if the region isn't generated yet
#
func get_generated_region(area: Rect2) -> Region:
    self.terrain_mutex.lock()
    var region = self.terrain.get(area)
    self.terrain_mutex.unlock()
    return region
