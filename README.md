# README

# Trips Management

The script takes a file with information about trips and returns the information about 
their itineraries in a more human friendly way.

## Requirements

### Ruby version
`Ruby 2.6.6`

### Rails version
`Rails 6.1.5`

### How to execute
The script can be simply run from terminal with following command:
```bash
BASE=<COPY_BASE_CITY_NAME_HERE> bundle exec ruby main.rb input_filename
```

This project contains two input files to check bevahiour: `input.rb` and `input_several_stays.rb`

## Deliverable history

We have decided to develop the exposed problem in an incremental iterative way, 
so the project grows gradually and in a controlled way through deliverable prototypes.

### First version
 
In the first version, the script opens the given file and collects just the input file 
lines that contain parseable times.
We catch the lines with dates by using Time library. 

For reference see this commit: https://github.com/EPCCTeresa/trips_management/commit/6f1e1d0e4520219a5556da68f404b200b402d693

#### Input File Sample

```bash
# input.txt

RESERVATION
SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10

RESERVATION
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10

RESERVATION
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50

RESERVATION
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30

RESERVATION
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17

RESERVATION
SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
```

#### Output 

```bash
SEGMENT: Flight SVQ 2023-03-02 06:40 -> BCN 09:10
SEGMENT: Hotel BCN 2023-01-05 -> 2023-01-10
SEGMENT: Flight SVQ 2023-01-05 20:40 -> BCN 22:10
SEGMENT: Flight BCN 2023-01-10 10:30 -> SVQ 11:50
SEGMENT: Train SVQ 2023-02-15 09:30 -> MAD 11:00
SEGMENT: Train MAD 2023-02-17 17:00 -> SVQ 19:30
SEGMENT: Hotel MAD 2023-02-15 -> 2023-02-17
SEGMENT: Flight BCN 2023-03-02 15:00 -> NYC 22:45
```

#### Result
Now we have interesting lines in an array collection so we can proceed to manipulate 
the array to structure the itinerary information in a more human friendly way.

### Second version

In the second deliverable we find 3 phases to create the desired structure to display the information:
- sort by date: we assume in this phase that the trips will not overlap between them
- sort by destination: computes the destination depending on if it is a roundtrip with or without stay. 
One roundtrip without stay will be considered a connection in case intercity transport has been 
contracted with a departure time less than 24 hours apart. 
- sort trip groups with hotels assuming that only after we move to the destination, it is time for accomodation


For second deliverable prototype reference see this commit: https://github.com/EPCCTeresa/trips_management/commit/64e38d7d6584f4cba6ed4e40a439e4c49ff1406f 

#### Output 

```bash
Trip to BCN
Flight SVQ 2023-01-05 20:40 -> BCN 22:10
Hotel BCN 2023-01-05 -> 2023-01-10
Flight BCN 2023-01-10 10:30 -> SVQ 11:50
Trip to MAD
Train SVQ 2023-02-15 09:30 -> MAD 11:00
Hotel MAD 2023-02-15 -> 2023-02-17
Train MAD 2023-02-17 17:00 -> SVQ 19:30
Trip to NYC
Flight SVQ 2023-03-02 06:40 -> BCN 09:10
Flight BCN 2023-03-02 15:00 -> NYC 22:45
```

# How to run test suite

```bash
BASE=<COPY_BASE_CITY_NAME_HERE> rspec
```

## Output of executing the tests by command


```
SimpleCov started successfully!

Randomized with seed 9991
........

Finished in 0.02291 seconds (files took 2.87 seconds to load)
8 examples, 0 failures

Randomized with seed 9991

Coverage report generated for RSpec to /Users/teresasimancasfernandez/trips_management/coverage. 85 / 85 LOC (100.0%) covered.

```

# How to check coverage file
In order to see file test coverage details, you can open in your favourite browser the file coverage/index.html or you can execute the following command: 

```open coverage/index.html```


# Improvements
1. It can be possible to book two different stays in the same destination, the script will include the hotels whose check-in dates are between the travel dates in the destination group.

Output example:

```bash
Trip to MAD
Train SVQ 2023-02-15 09:30 -> MAD 11:00
Hotel MAD 2023-02-15 -> 2023-02-16
Hotel MAD 2023-02-16 -> 2023-02-17
Train MAD 2023-02-17 17:00 -> SVQ 19:30
```

2. High tests coverage(100%)
3. Rubocop installed, so it can be extended in order to create project programming style so that the code remains uniform, ordered and standardized
