drums = [:drum_heavy_kick, :drum_tom_mid_soft, :drum_tom_mid_hard, :drum_tom_lo_soft, :drum_tom_lo_hard, :drum_tom_hi_soft, :drum_tom_hi_hard, :drum_splash_soft, :drum_splash_hard, :drum_snare_soft, :drum_snare_hard, :drum_cymbal_soft, :drum_cymbal_hard, :drum_cymbal_open, :drum_cymbal_closed, :drum_cymbal_pedal, :drum_bass_soft, :drum_bass_hard, :elec_triangle, :elec_snare, :elec_lo_snare, :elec_hi_snare, :elec_mid_snare, :elec_cymbal, :elec_soft_kick, :elec_filt_snare, :elec_fuzz_tom, :elec_chime, :elec_bong, :elec_twang, :elec_wood, :elec_pop,  :elec_blip, :elec_blip2, :elec_ping, :elec_bell, :elec_flip, :elec_tick, :elec_hollow_kick, :elec_twip, :elec_plip, :elec_blup, :sn_dub, :sn_dolf, :sn_zome, :bd_ada, :bd_pure, :bd_808, :bd_zum, :bd_gas, :bd_sone, :bd_haus, :bd_zome, :bd_boom, :bd_klub, :bd_fat, :bd_tek]

live_loop :drums do
  sample drums.choose
  sleep rrand(0.0, 1)
end

live_loop :notes do
  note = rrand_i(42, 110)
  #| note = [chord(:E3, :major), chord(:A3, :major)].flatten.choose
  #| made it 'sadder' somehow, whether minor or major
  play note

  sleep 0.5
end
