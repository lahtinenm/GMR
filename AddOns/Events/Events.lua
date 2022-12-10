Events = {}

local _ = {}

local frame = nil
local entries = {}
local registeredEvents = {}

local function finish(entry, wasSuccessful, event, ...)
  _.cleanUpEntry(entry)

  if Object.isEmpty(registeredEvents) then
    frame:SetScript('OnEvent', nil)
  end

  Coroutine.resumeWithShowingError(entry.thread, wasSuccessful, event, ...)
end

function _.cleanUpEntry(entry)
  _.cancelTimerOfEntry(entry)
  _.removeRegisteredEventsOfEntry(entry)
  _.cleanUpRegisteredEvents()
  Array.removeFirstOccurence(entries, entry)
end

function _.cancelTimerOfEntry(entry)
  if entry.timer and not entry.timer:IsCancelled() then
    entry.timer:Cancel()
  end
end

function _.removeRegisteredEventsOfEntry(entry)
  for _, event in ipairs(entry.eventsToWaitFor) do
    Set.remove(registeredEvents, event)
  end
end

function _.cleanUpRegisteredEvents()
  for event, registrations in pairs(registeredEvents) do
    if Set.isEmpty(registrations) then
      frame:UnregisterEvent(event)
      Object.remove(registeredEvents, event)
    end
  end
end

function Events.waitForOneOfEventsAndCondition(eventsToWaitFor, condition, timeout)
  local entry = {
    eventsToWaitFor = eventsToWaitFor,
    condition = condition,
    timeout = timeout,
    timer = nil,
    thread = coroutine.running()
  }

  table.insert(entries, entry)

  if not frame then
    frame = CreateFrame('Frame')
  end

  if not frame:GetScript('OnEvent') then
    frame:SetScript('OnEvent', function(self, event, ...)
      for _, entry in ipairs(entries) do
        if entry.condition(self, event, ...) then
          finish(entry, true, event, ...)
        end
      end
    end)
  end

  for _, event in ipairs(eventsToWaitFor) do
    frame:RegisterEvent(event)
    if not registeredEvents[event] then
      registeredEvents[event] = Set.create()
    end
    Set.add(registeredEvents[event], entry)
  end

  if timeout then
    entry.timer = C_Timer.NewTimer(timeout, function()
      finish(entry, false)
    end)
  end

  return coroutine.yield()
end

function Events.waitForOneOfEvents(eventsToWaitFor, timeout)
  return Events.waitForOneOfEventsAndCondition(eventsToWaitFor, Function.alwaysTrue, timeout)
end

function Events.waitForEventCondition(eventToWaitFor, condition, timeout)
  return Events.waitForOneOfEventsAndCondition({ eventToWaitFor }, condition, timeout)
end

function Events.waitForEvent(eventToWaitFor, timeout)
  return Events.waitForEventCondition(eventToWaitFor, Function.alwaysTrue, timeout)
end
