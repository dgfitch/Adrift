require("oo.lua")
require("util/geom.lua")
require("util/string.lua")

function table.shallow_copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

-- extremely naïve
function table.invert(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[v] = k
  end
  return t2
end

Poly = {
  create = function(self, points)
    local result = {}
    mixin(result,Poly)
    result.points = points
    result.sortpoints = table.shallow_copy(points)
    -- note: assumes polys cannot be defined at the same point
    result.inverse = table.invert(points)
    return result
  end,

  next_point = function(self, i)
    return self.points[i % #self.points + 1]
  end,

  sort_first = function(self, f)
    table.sort(self.sortpoints, f)
    return self.sortpoints[1]
  end,

  min_x_point = function(self) return self:sort_first( function(a,b) return a.x < b.x end ) end,
  min_x       = function(self) return self:min_x_point().x end,
  max_x_point = function(self) return self:sort_first( function(a,b) return a.x > b.x end ) end,
  max_x       = function(self) return self:max_x_point().x end,
  min_y_point = function(self) return self:sort_first( function(a,b) return a.y < b.y end ) end,
  min_y       = function(self) return self:min_y_point().y end,
  max_y_point = function(self) return self:sort_first( function(a,b) return a.y > b.y end ) end,
  max_y       = function(self) return self:max_y_point().y end,

  bounding_box = function(self)
    return {
        {x=self:min_x(),y=self:min_y()},
        {x=self:max_x(),y=self:max_y()}
      }
  end,

  -- Returns intersections as {endpoint1, endpoint2, intersectionpoint}
  intersections_with = function(self, p1, p2)
    local intersections = {}

    local box = self:bounding_box()

    if not geom.box_overlap_t(box[1], box[2], p1, p2) then return intersections end

    for i,v in ipairs(self.points) do
      local w = self:next_point(i)
      local intersect_point = geom.intersection_point_t(v,w,p1,p2,false)
      if intersect_point~=nil then
        local intersection = {v,w,intersect_point}
        table.insert(intersections, intersection)
      end 
    end
    return intersections
  end,

  closest_intersection = function(poly, p1, p2)
    local intersections = poly:intersections_with(p1, p2)
    if (#intersections > 0) then
      pp ("checking intersections", intersections)
      local ip = {}
      -- compute distances -- maybe there is a cheaper way?
      -- also, sometimes we may be past a segment of the line that intersects
      for i,v in ipairs(intersections) do
        table.insert(ip,{v[1],v[2],v[3], geom.distance_t(p1,v[3])})
      end
      local f = function(h,i) return h[4] < i[4] end
      table.sort(ip, f)
      return ip[1]
    else
      return nil
    end
  end,

  union_with = function(s, p)
    local points = {}
    
    local s_index, p_index = 0, 0
    local minsx = s:min_x_point()
    local minpx = p:min_x_point()
    
    if minpx.x < minsx.x then
      -- start from the second poly instead
      p, s = s, p
      minpx, minsx = minsx, minpx
      -- TODO: Should have something for the degenerate case, where min s x = min p x, because then the algorithm has a chance of ½ to start moving through the union incorrectly...
    end

    local start = minsx

    local cursor = start
    local s_index = s.inverse[minsx]
    local cursor_next = s:next_point(s_index)

    while (#points == 0 or cursor ~= start) do
      pp ("cursor", cursor)
      pp ("cursor_next", cursor_next)

      table.insert(points, cursor)

      local intersection = p:closest_intersection(cursor, cursor_next)
      if (intersection) then
        local end1, end2, point = intersection[1], intersection[2], intersection[3]

        pp ("end1", end1)
        pp ("end2", end2)
        pp ("point", point)

        local destination 
        -- Which endpoint do we move towards?
        if geom.ccw_t(cursor, point, end1) then
          destination = end2
        else
          destination = end1
        end
        cursor = point
        cursor_next = destination
        -- Now we're operating on the other polygon, so swap
        p, s = s, p
      else
        cursor = cursor_next
        s_index = s.inverse[cursor]
        cursor_next = s:next_point(s_index)
      end
    end

    return Poly:create(points)
    
  end,
}
