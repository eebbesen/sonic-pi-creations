@drums = [:drum_heavy_kick, :drum_tom_mid_soft, :drum_tom_mid_hard, :drum_tom_lo_soft, :drum_tom_lo_hard, :drum_tom_hi_soft, :drum_tom_hi_hard, :drum_splash_soft, :drum_splash_hard, :drum_snare_soft, :drum_snare_hard, :drum_cymbal_soft, :drum_cymbal_hard, :drum_cymbal_open, :drum_cymbal_closed, :drum_cymbal_pedal, :drum_bass_soft, :drum_bass_hard, :elec_triangle, :elec_snare, :elec_lo_snare, :elec_hi_snare, :elec_mid_snare, :elec_cymbal, :elec_soft_kick, :elec_filt_snare, :elec_fuzz_tom, :elec_chime, :elec_bong, :elec_twang, :elec_wood, :elec_pop,  :elec_blip, :elec_blip2, :elec_ping, :elec_bell, :elec_flip, :elec_tick, :elec_hollow_kick, :elec_twip, :elec_plip, :elec_blup, :sn_dub, :sn_dolf, :sn_zome, :bd_ada, :bd_pure, :bd_808, :bd_zum, :bd_gas, :bd_sone, :bd_haus, :bd_zome, :bd_boom, :bd_klub, :bd_fat, :bd_tek]

# default range avoids hard-to-hear notes
# gives a mysterious feel
def random_note(low = 42, high = 110)
  rrand_i(low, high)
end

# made it 'sadder' somehow, whether minor or major
def random_chord_note
  chords = [chord(:E3, :major), chord(:A3, :major)]
  chords.flatten.choose
end

def random_chord
  chords = [chord(:E3, :major), chord(:A3, :major)]
  chords.choose
end

def snare
  with_fx :reverb do
    sample :drum_snare_hard, pan: -0.3
  end
end

def kick
  with_fx :reverb do
    sample :drum_heavy_kick
    sample :bd_boom, amp: 10
    sample :drum_tom_mid_soft, pan: 0.3
  end
end

# doubles the hi-hat if sleep time is passed in
def hh(sleep_time = nil)
  sample :drum_cymbal_pedal, pan: -0.8
  if sleep_time
    sleep sleep_time
    hh
  end
end

# @dhh will double the hi-hat
# by default hi-hat already between kick and snare
def explicit_drums(sleep_time)
  hhs = @dhh ? sleep_time / 2 : nil
  puts "NON-EVEN DRUMS: sleep #{hhs}; dhh: #{@dhh}"

  kick
  hh hhs
  sleep hhs || sleep_time

  hh hhs
  sleep hhs || sleep_time

  snare
  hh hhs
  sleep hhs || sleep_time

  hh hhs
  sleep hhs || sleep_time
end

# @dhh will double the high hat
def explicit_drums_even(sleep_time)
  hhs = @dhh ? sleep_time / 2 : nil
  puts "EVEN DRUMS: sleep #{hhs}; dhh: #{@dhh}"

  kick
  hh hhs
  sleep hhs || sleep_time

  snare
  hh hhs
  sleep hhs || sleep_time
end

# provides incrment for linear progression
# from span to target value
def coalesce_to_tempo(target, span, start = [0,1])
  low = start[0]
  high = start[1]

  (target - (high - low)).abs / span
end

def adj
  @interval * @counter
end

# as we move from chaos to order remove synthetic drum sounds
def alter_drums
  return if @drums_altered
  @drums = @drums.select{|i| i.to_s.start_with? 'drum'}
  @drums_altered = true
  puts "ALTERED DRUMS AT COUNTER #{@counter} and RANDOM_COUNTER #{@random_counter}"
end

## instance variables for sharing
@target_sleep = 0.5
@loops_to_interval = 20
@interval = coalesce_to_tempo(@target_sleep, @loops_to_interval)
@counter = 0 # numbrer of times driving loop has been called
@random_counter = 0 # number of times random_drums has been called
@synced = false # when random drums get synced to main thread
@dhh = false # double hi-hat if true
@drums_altered = false

# gverb on random drum sounds linearly lessens
live_loop :random_drums do
  with_fx :gverb, room: [1.5 - adj, 1.0].max, dry: adj * 10, mix: [[0.3 - adj/10, 0].max , 0.3].min do
    sample @drums.choose
  end
  if @random_counter < @loops_to_interval
    sleep rrand(0 + adj, 1 - adj)
  elsif @random_counter == @loops_to_interval
    sync :tick
    @synced = true
    @start_sync = @counter
  elsif @random_counter > 2 * @loops_to_interval
    stop
  else
    sync :tick
    sleep @target_sleep + adj
  end
  @random_counter += 1

  if @random_counter > (@loops_to_interval * 1.5)
    alter_drums
  end
end

# gradually, linearly move into constant tempo
# set @dhh to double the hihat tempo
# set @start_sync to control even or uneven drums
live_loop :explicit_drums do
  sync :tick
  if @synced
    base_sleep = if 3 - adj > 2
      3 - adj
    else
      2
    end

    if @counter - @start_sync > 70 && @counter - @start_sync < 125
      explicit_drums_even(base_sleep)
    else
      explicit_drums(base_sleep)
    end
  end
end

# driving loop -- controls tick and counter
live_loop :notes do
  note = random_note
  play note
  cue :tick

  @dhh = true if @counter > 5 * @loops_to_interval
  @dhh = false if @counter > 9 * @loops_to_interval
  sleep @target_sleep
  @counter += 1
  puts "COUNTER: #{@counter}"
  puts "START_SYNC: #{@start_sync}"
  puts "LOOPS_TO_INTERVAL: #{@loops_to_interval}"
  puts "ADJ: #{adj}"
  puts "DHH: #{@dhh}"
end
